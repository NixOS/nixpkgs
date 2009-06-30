args : with args;
	let localDefs = builderDefs.passthru.function {
		src = fetchurl {
			url = http://snapshots.madwifi.org/madwifi-trunk/madwifi-trunk-r3693-20080602.tar.gz;
			sha256 = "0r9nnxcq50rgwcm9y93rpk3mqknl3ixkxkd72437b55qlz1f9vs3";
		};

		buildInputs = [];
		configureFlags = [];
		makeFlags = [''KERNELPATH=${kernel}/lib/modules/*/build'' ''DESTDIR=$out''];
		hal20080528 = fetchurl {
		  url = http://people.freebsd.org/~sam/ath_hal-20080528.tgz;
		  sha256 = "1a6glkd8n46876hl48ib08p81qwsvrk4153j4b9xrxgid6f8bar9";
		};
	};
	in with localDefs;
let
preBuild = fullDepEntry (''
	echo Replacing HAL.
	tar xvf ${hal20080528}
	rm -r hal
	mv ath_hal-* hal
'') ["minInit" "doUnpack"];
postInstall = fullDepEntry (''
	ln -s $out/usr/local/bin $out/bin
'') [minInit doMakeInstall];
in
stdenv.mkDerivation rec {
	name = "atheros-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			((lib.optional 
				(lib.attrByPath ["freshHAL"] false args)
				preBuild)
			++ [doMakeInstall postInstall
			doForceShare doPropagate]));
	meta = {
		description = "Atheros WiFi driver";
		inherit src;
	};
}
