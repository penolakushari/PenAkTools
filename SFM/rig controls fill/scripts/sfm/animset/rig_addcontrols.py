import vs
import re

defaultRoot = "rootTransform"

def CheckConstraints(ExistControls, Ignore, animSet):
	for op in animSet.operators:
		if op == None: continue
		
		match = re.match(r"(pointConstraint_|orientConstraint_|ikConstraint_)(.*)", op.GetName())
		if match == None: continue
		bone = match.group(2)
		
		if match.group(1) == "ikConstraint_":
			nameStart = re.match(r"bone \d+ \((.*)\)", op.startJoint.target.GetName())
			if nameStart != None:
				nameStart = nameStart.group(1)
				Ignore[nameStart] = True

			nameMid = re.match(r"bone \d+ \((.*)\)", op.midJoint.target.GetName())
			if nameMid != None:
				nameMid = nameMid.group(1)
				Ignore[nameMid] = True
		if not bone in ExistControls:
			control = op.targets[0].GetName()
			ExistControls[bone] = control

def BuildSkeletonData(UsedBones, ExistControls, parent, parentName):
	for bone in parent.children:
		if bone == None: continue
		
		name = re.match(r"bone \d+ \((.*)\)", bone.GetName())
		if name == None:continue
		
		name = name.group(1)
		constraint = None if not name in ExistControls else ExistControls[name]
		UsedBones[name] = {"parent": parentName, "constraint": constraint, "children": {}}
		BuildSkeletonData(UsedBones[name]["children"], ExistControls, bone, name)

def CreateRigFills(UsedBones, root, rootGroup, Ignore):
	sfm.SetOperationMode("Pass")
	
	sfm.SelectAll()
	sfm.SetReferencePose()

	NewRigHandles = []
	def CreateBaseRecursion(UsedBones, NewRigHandles):
		for bname in UsedBones:
			d = UsedBones[bname]
			if d["constraint"] == None:
				bone = sfmUtils.FindFirstDag([bname], False)
				if bone == None: continue
				rigBone = sfmUtils.CreateConstrainedHandle("rig_" + bname, bone, bCreateControls=False)
				d["constraint"] = rigBone
				d["bone"] = bone
				NewRigHandles.append(rigBone)
			else:
				rigBone = sfmUtils.FindFirstDag([ d["constraint"] ], True)
				d["constraint"] = rigBone
			
			CreateBaseRecursion(d["children"], NewRigHandles)
	
	if defaultRoot == root:
		boneRoot = sfmUtils.FindFirstDag(["RootTransform"], True)
		rigRoot = sfmUtils.CreateConstrainedHandle("rig_root", boneRoot, bCreateControls=False)
		NewRigHandles.append(rigRoot)
	else:
		rigRoot = sfmUtils.FindFirstDag([root], True)
	
	CreateBaseRecursion(UsedBones, NewRigHandles)

	sfm.ClearSelection()
	sfmUtils.SelectDagList(NewRigHandles)
	sfm.GenerateSamples()
	sfm.RemoveConstraints()
	
	def ParentRecursion(UsedBones, NewRigHandles, parent):
		for bname in UsedBones:
			d = UsedBones[bname]
			control = d["constraint"]
			if control in NewRigHandles:
				sfmUtils.ParentMaintainWorld(control, parent)
			ParentRecursion(d["children"], NewRigHandles, control)
	
	ParentRecursion(UsedBones, NewRigHandles, rigRoot)
	
	sfm.SetDefault()

	if rigRoot in NewRigHandles:
		sfmUtils.CreatePointOrientConstraint(rigRoot, boneRoot)

	def CreateConstraintsRecursion(UsedBones, NewRigHandles, Ignore):
		for bname in UsedBones:
			d = UsedBones[bname]
			control = d["constraint"]
			if control in NewRigHandles:
				if not bname in Ignore:
					sfmUtils.CreatePointOrientConstraint(control, d["bone"])
				else:
					sfmUtils.CreatePointOrientConstraint(d["bone"], control)
			CreateConstraintsRecursion(d["children"], NewRigHandles, Ignore)
	
	CreateConstraintsRecursion(UsedBones, NewRigHandles, Ignore)

	rigBodyGroup = rootGroup.CreateControlGroup( "RigSalad" )
	for control in NewRigHandles:
		sfmUtils.AddDagControlsToGroup(rigBodyGroup, control)

def main():
	UsedBones, ExistControls = {}, {}
	Ignore = {}
	
	shot = sfm.GetCurrentShot()
	animSet = sfm.GetCurrentAnimationSet()
	gameModel = animSet.gameModel
	rootGroup = animSet.GetRootControlGroup()
	
	CheckConstraints(ExistControls, Ignore, animSet)
	root = defaultRoot if not defaultRoot in ExistControls else ExistControls[defaultRoot]
	BuildSkeletonData(UsedBones, ExistControls, gameModel, root)
	del ExistControls
	rig = sfm.BeginRig("rig_addcontrols_" + animSet.GetName())
	if rig == None: return
	
	CreateRigFills(UsedBones, root, rootGroup, Ignore)
	
	sfm.EndRig()
	
	del UsedBones
	return

main()
