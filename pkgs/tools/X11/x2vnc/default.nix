
args : with args; with builderDefs.passthru.function {src="";};
	let localDefs = builderDefs.passthru.function ((rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://fredrik.hubbe.net/x2vnc/x2vnc-1.7.2.tar.gz;
			sha256 = "00bh9j3m6snyd2fgnzhj5vlkj9ibh69gfny9bfzlxbnivb06s1yw";
		};

		buildInputs = [libX11 xproto xextproto libXext libXrandr randrproto];
		doCreatePrefix = fullDepEntry (''
			ensureDir $out
		'') ["defEnsureDir"];
		configureFlags = [];
	}) // args); /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "x2vnc-1.7.2";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doConfigure doCreatePrefix doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "A program to control a remote VNC server";
		inherit src;
	};
}
