{
  builderDefs
}:
let makeDictdDBFreedict = _src: _name:
with builderDefs {src="";} null;
	let localDefs = builderDefs (rec {
		src=_src;
		doInstall = FullDepEntry (''
			ensureDir $out/share/dictd
			tar xf  ${src} -C $out/share/dictd
		'') ["minInit" "addInputs" "defEnsureDir"];

		buildInputs = [];
		configureFlags = [];
	}) null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "dictd-db-${_name}";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doInstall doForceShare doPropagate]);
	meta = {
		description = "
		${name} dictionary for dictd.
";
		inherit src;
	};
};
fetchurl = (builderDefs {src="";} null).fetchurl;
in 
{
	nld2eng = makeDictdDBFreedict (fetchurl {
		url = http://prdownloads.sourceforge.net/freedict/nld-eng.tar.gz;
		sha256 = "1vhw81pphb64fzsjvpzsnnyr34ka2fxizfwilnxyjcmpn9360h07";
	}) "nld-eng";
	eng2nld =  makeDictdDBFreedict (fetchurl {
		url = http://downloads.sourceforge.net/freedict/eng-nld.tar.gz;
		sha256 = "0rcg28ldykv0w2mpxc6g4rqmfs33q7pbvf68ssy1q9gpf6mz7vcl";
	}) "eng-nld";
}
/*	fetchurl {
		url = http://downloads.sourceforge.net/freedict/eng-rus.tar.gz;
		sha256 = "15409ivhww1wsfjr05083pv6mg10bak8v5pg1wkiqybk7ck61rry";
	};
	fetchurl {
		url = http://downloads.sourceforge.net/freedict/rus-eng.tar.gz;
		sha256 = "";
	};
	fetchurl {
		url = http://downloads.sourceforge.net/freedict/fra-eng.tar.gz;
		sha256 = "0sdd88s2zs5whiwdf3hd0s4pzzv75sdsccsrm1wxc87l3hjm85z3";
	};
	fetchurl {
		url = http://downloads.sourceforge.net/freedict/eng-fra.tar.gz;
		sha256 = "0fi6rrnbqnhc6lq8d0nmn30zdqkibrah0mxfg27hsn9z7alwbj3m";
	};
	fetchurl {
		url = http://downloads.sourceforge.net/mueller-dict/mueller-dict-3.1.tar.gz;
		sha256 = "04r5xxznvmcb8hkxqbjgfh2gxvbdd87jnhqn5gmgvxxw53zpwfmq";
	};*/
