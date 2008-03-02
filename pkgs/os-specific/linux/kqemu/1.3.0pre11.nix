args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://fabrice.bellard.free.fr/qemu/kqemu-1.3.0pre11.tar.gz;
			sha256 = "03svg2x52ziglf9r9irf6ziiz8iwa731fk1mdskwdip5jxbyy6jl";
		};
		buildInputs = [];
		configureFlags = [''--prefix=$out'' ''--kernel-path=$(ls -d ${kernel}/lib/modules/*/build)''];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let 
  debugStep = FullDepEntry (''
  	cat config-host.mak
  '') [minInit];
  preConfigure = FullDepEntry ('' 
  	sed -e 's/`uname -r`/'"$(basename ${kernel}/lib/modules/*)"'/' -i install.sh
  	sed -e '/kernel_path=/akernel_path=$out$kernel_path' -i install.sh
	sed -e '/depmod/d' -i install.sh
	cat install.sh
  '') [minInit doUnpack];
in
stdenv.mkDerivation rec {
	name = "kqemu-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [preConfigure doConfigure debugStep doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		Kernel module for Qemu acceleration
";
		inherit src;
	};
}
