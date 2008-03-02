args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://snapshots.madwifi.org/madwifi-ng/madwifi-ng-r2756-20071018.tar.gz;
			sha256 = "0mm1kx9pjvvla792rv7k48yhsa0fpzvd1717g9xzazjsz2mqwzyv";
		};

		buildInputs = [];
		configureFlags = [];
		makeFlags = [''KERNELPATH=${kernel}/lib/modules/*/build'' ''DESTDIR=$out''];
		patchAR2425x86 = (if args ? pci001c_rev01 && args.pci001c_rev01 then
		fetchurl {
			url = http://madwifi.org/attachment/ticket/1679/madwifi-ng-0933.ar2425.20071130.i386.patch?format=raw;
			name = "madwifi-AR2425-x86.patch";
			sha256 = "11xpx5g9w7ilagvj60prc3s8a3x0n5n4mr0b7nh0lxwrbjdgjjfg";
		} else "");
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let 
doPatch = FullDepEntry (if patchAR2425x86 !="" then ''
	cd hal
	patch -Np1 -i ${patchAR2425x86}
	cd ..
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
