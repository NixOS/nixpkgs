{ builderDefs }:

let makeDictdDB = _src: _name: _subdir: _locale:
with builderDefs;
	let localDefs = builderDefs.passthru.function (rec {
		src=_src;
		doInstall = fullDepEntry (''
			mkdir -p $out/share/dictd
			tar xf  ${src}
			cp $(ls ./${_subdir}/*.{dict*,index} || true) $out/share/dictd 
			echo "${_locale}" >$out/share/dictd/locale
		'') ["minInit" "addInputs" "defEnsureDir"];

		buildInputs = [];
		configureFlags = [];
	});
	in with localDefs;
stdenv.mkDerivation rec {
	name = "dictd-db-${_name}";
	locale = _locale;
	dbName = _name;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doInstall doForceShare doPropagate]);
	meta = {
		description = "${name} dictionary for dictd";
	};
};
# Probably a bug in some FreeDict release files, but easier to trivially
# work around than report. Not that it can cause any other problems..
makeDictdDBFreedict = _src: _name: _locale: makeDictdDB _src _name "{.,bin}" _locale;
fetchurl = builderDefs.fetchurl;

in 

rec {
	nld2eng = makeDictdDBFreedict (fetchurl {
		url = http://prdownloads.sourceforge.net/freedict/nld-eng.tar.gz;
		sha256 = "1vhw81pphb64fzsjvpzsnnyr34ka2fxizfwilnxyjcmpn9360h07";
	}) "nld-eng" "nl_NL";
	eng2nld =  makeDictdDBFreedict (fetchurl {
		url = http://downloads.sourceforge.net/freedict/eng-nld.tar.gz;
		sha256 = "0rcg28ldykv0w2mpxc6g4rqmfs33q7pbvf68ssy1q9gpf6mz7vcl";
	}) "eng-nld" "en_UK";
	eng2rus = makeDictdDBFreedict (fetchurl {
		url = http://downloads.sourceforge.net/freedict/eng-rus.tar.gz;
		sha256 = "15409ivhww1wsfjr05083pv6mg10bak8v5pg1wkiqybk7ck61rry";
	}) "eng-rus" "en_UK";
	fra2eng = makeDictdDBFreedict (fetchurl {
		url = http://downloads.sourceforge.net/freedict/fra-eng.tar.gz;
		sha256 = "0sdd88s2zs5whiwdf3hd0s4pzzv75sdsccsrm1wxc87l3hjm85z3";
	}) "fra-eng" "fr_FR";
	eng2fra = makeDictdDBFreedict (fetchurl {
		url = http://downloads.sourceforge.net/freedict/eng-fra.tar.gz;
		sha256 = "0fi6rrnbqnhc6lq8d0nmn30zdqkibrah0mxfg27hsn9z7alwbj3m";
	}) "eng-fra" "en_UK";
	mueller_eng2rus_pkg = makeDictdDB (fetchurl {
		url = http://downloads.sourceforge.net/mueller-dict/mueller-dict-3.1.tar.gz;
		sha256 = "04r5xxznvmcb8hkxqbjgfh2gxvbdd87jnhqn5gmgvxxw53zpwfmq";
	}) "mueller-eng-rus" "mueller-dict-*/dict" "en_UK";
	mueller_enru_abbr = {
		outPath = "${mueller_eng2rus_pkg}/share/dictd/mueller-abbrev";
		name = "mueller-abbr";
		dbName = "mueller-abbr";
		locale = "en_UK";
	};
	mueller_enru_base = {
		outPath = "${mueller_eng2rus_pkg}/share/dictd/mueller-base";
		name = "mueller-base";
		dbName = "mueller-base";
		locale = "en_UK";
	};
	mueller_enru_dict = {
		outPath = "${mueller_eng2rus_pkg}/share/dictd/mueller-dict";
		name = "mueller-dict";
		dbName = "mueller-dict";
		locale = "en_UK";
	};
	mueller_enru_geo = {
		outPath = "${mueller_eng2rus_pkg}/share/dictd/mueller-geo";
		name = "mueller-geo";
		dbName = "mueller-geo";
		locale = "en_UK";
	};
	mueller_enru_names = {
		outPath = "${mueller_eng2rus_pkg}/share/dictd/mueller-names";
		name = "mueller-names";
		dbName = "mueller-names";
		locale = "en_UK";
	};
}
