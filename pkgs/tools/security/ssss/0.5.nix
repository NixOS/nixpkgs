args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://point-at-infinity.org/ssss/ssss-0.5.tar.gz;
			sha256 = "15grn2fp1x8p92kxkwbmsx8rz16g93y9grl3hfqbh1jn21ama5jx";
		};

		buildInputs = [gmp];
		configureFlags = [];
		doPatch = fullDepEntry (''
			sed -e s@/usr/@$out/@g -i Makefile
			cp ssss.manpage.xml ssss.1
			cp ssss.manpage.xml ssss.1.html
			ensureDir $out/bin $out/share/man/man1
			echo -e 'install:\n\tcp ssss-combine ssss-split '"$out"'/bin' >>Makefile
		'') ["minInit" "doUnpack" "defEnsureDir"];
	});
	in with localDefs;
stdenv.mkDerivation rec {
	name = "ssss-0.5";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			["doPatch" doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "Shamir Secret Sharing Scheme";
		inherit src;
	};
}
