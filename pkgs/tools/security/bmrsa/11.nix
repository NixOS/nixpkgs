args : with args; with builderDefs;
	let localDefs = builderDefs.meta.function (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://prdownloads.sourceforge.net/sourceforge/bmrsa/bmrsa11.zip;
			sha256 = "0ksd9xkvm9lkvj4yl5sl0zmydp1wn3xhc55b28gj70gi4k75kcl4";
		};

		buildInputs = [unzip];
		configureFlags = [];
		doUnpack = FullDepEntry (''
			mkdir bmrsa
			cd bmrsa 
			unzip ${src}
			sed -e 's/gcc/g++/' -i Makefile
			ensureDir $out/bin
			echo -e 'install:\n\tcp bmrsa '$out'/bin' >> Makefile
		'') ["minInit" "addInputs" "defEnsureDir"];
	});
	in with localDefs;
stdenv.mkDerivation rec {
	name = "bmrsa-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		RSA utility.
";
		inherit src;
	};
}
