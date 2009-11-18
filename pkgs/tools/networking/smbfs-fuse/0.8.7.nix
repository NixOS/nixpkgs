args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://www.ricardis.tudelft.nl/~vincent/fusesmb/download/fusesmb-0.8.7.tar.gz;
			sha256 = "12gz2gn9iqjg27a233dn2wij7snm7q56h97k6gks0yijf6xcnpz1";
		};

		buildInputs = [samba fuse];
		configureFlags = [];
		postInstall = fullDepEntry 
		(''
		ensureDir $out/lib
		ln -fs ${samba}/lib/libsmbclient.so $out/lib/libsmbclient.so.0
		'')
		[ "minInit" "defEnsureDir" "doMakeInstall"];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "smbfs-fuse-0.8.7";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doConfigure doMakeInstall postInstall doForceShare doPropagate]);
  meta = {
   description = "Samba mounted via FUSE";
   inherit src;
  };
}
