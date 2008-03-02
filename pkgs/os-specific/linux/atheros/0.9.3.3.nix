args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://downloads.sourceforge.net/madwifi/madwifi-0.9.3.3.tar.bz2;
			sha256 = "1dq56dx81wfhpgipbrl3gk2is3g1xvysx2pl6vxyj0dhslkcnf3y";
		};

		buildInputs = [];
		configureFlags = [];
		makeFlags = [''KERNELPATH=${kernel}/lib/modules/*/build'' ''DESTDIR=$out''];
		patchAR2425x86 = ""; /*(if args ? pci001c_rev01 && args.pci001c_rev01 then
		fetchurl {
			url = http://madwifi.org/attachment/ticket/1679/madwifi-ng-0933.ar2425.20071130.i386.patch?format=raw;
			name = "madwifi-AR2425-x86.patch";
			sha256 = "11xpx5g9w7ilagvj60prc3s8a3x0n5n4mr0b7nh0lxwrbjdgjjfg";
		} else "")*/;
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let 
doPatch = FullDepEntry (if patchAR2425x86 !="" then ''
	cd hal
	patch -Np1 -i ${patchAR2425x86}
'' else "") [minInit doUnpack];
postInstall = FullDepEntry (''
	ln -s $out/usr/local/bin $out/bin
'') [minInit doMakeInstall];
in
stdenv.mkDerivation rec {
	name = "atheros-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doPatch doMakeInstall 
			postInstall doForceShare doPropagate]);
	meta = {
		description = "
		Atheros WiFi driver.
";
	};
}
