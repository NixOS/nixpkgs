args : with args;
	let localDefs = builderDefs.meta.function {
		src = fetchurl {
			url = http://snapshots.madwifi.org/madwifi-trunk/madwifi-trunk-r3867-20080924.tar.gz;
			sha256 = "0m48p5mqx1d3aimjjiy251fii7x7y15ch5n74hvq4hygc6bcjf79";
		};

		buildInputs = [];
		configureFlags = [];
		makeFlags = [''KERNELPATH=${kernel}/lib/modules/*/build'' ''DESTDIR=$out''];
		hal20080528 = fetchurl {
		  url = http://people.freebsd.org/~sam/ath_hal-20080528.tgz;
		  sha256 = "1a6glkd8n46876hl48ib08p81qwsvrk4153j4b9xrxgid6f8bar9";
		};
		injectionPatchFile = ./inj.patch;
	};
	in with localDefs;
let
preBuild = FullDepEntry (''
	echo Replacing HAL.
	tar xvf ${hal20080528}
	rm -r hal
	mv ath_hal-* hal
'') ["minInit" "doUnpack"];
postInstall = FullDepEntry (''
	ln -s $out/usr/local/bin $out/bin
'') [minInit doMakeInstall];
in
stdenv.mkDerivation rec {
	name = "atheros-"+version;
	patches = lib.optional
		(lib.getAttr ["injectionPatch"] false args)
		injectionPatchFile;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			((lib.optional 
				(lib.getAttr ["freshHAL"] false args)
				preBuild)
			++ [doPatch doMakeInstall postInstall
			doForceShare doPropagate]));
	meta = {
		description = "
		Atheros WiFi driver.
";
		inherit src;
	};
}
