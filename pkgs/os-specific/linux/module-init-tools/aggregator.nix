args : with args;
	let localDefs = builderDefs {
		addSbinPath = true;
		src = "";
		buildInputs = [module_init_tools];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let 

doCollect = FullDepEntry (''
ensureDir $out/lib/modules
cd $out/
for i in $moduleSources; do 
	cp -rfs $i/* .
	chmod -R u+w .
done
rm -rf nix-support
cd lib/modules/
rm */modules.*
MODULE_DIR=$PWD/ depmod -a 
cd $out/
'') [minInit addInputs defEnsureDir];
in
stdenv.mkDerivation rec {
	name = "kernel-modules";
	inherit moduleSources;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doCollect doForceShare doPropagate]);
	meta = {
		description = "
		A directory to hold all  the modules, including those 
		built separately from kernel. Later mentioned directories in 
		moduleSources have higher priority.
";
	};
}
