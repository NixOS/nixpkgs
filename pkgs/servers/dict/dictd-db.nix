{
  lib,
  stdenv,
  fetchurl,
  callPackage,
}:

let
  # Probably a bug in some FreeDict release files, but easier to trivially
  # work around than report. Not that it can cause any other problems..
  makeDictdDBFreedict =
    src: name: locale:
    makeDictdDB src name "{.,bin}" locale;

  makeDictdDB =
    src: _name: _subdir: _locale:
    stdenv.mkDerivation {
      name = "dictd-db-${_name}";
      inherit src;
      locale = _locale;
      dbName = _name;
      dontBuild = true;
      unpackPhase = ''
        tar xf  ${src}
      '';
      installPhase = ''
        mkdir -p $out/share/dictd
        cp $(ls ./${_subdir}/*.{dict*,index} || true) $out/share/dictd
        echo "${_locale}" >$out/share/dictd/locale
      '';

      meta = {
        description = "dictd-db dictionary for dictd";
        platforms = lib.platforms.linux;
      };
    };
in
rec {
  deu2eng = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/deu-eng.tar.gz";
    sha256 = "0dqrhv04g4f5s84nbgisgcfwk5x0rpincif0yfhfh4sc1bsvzsrb";
  }) "deu-eng" "de_DE";
  eng2deu = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/eng-deu.tar.gz";
    sha256 = "01x12p72sa3071iff3jhzga8588440f07zr56r3x98bspvdlz73r";
  }) "eng-deu" "en_EN";
  nld2eng = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/nld-eng.tar.gz";
    sha256 = "1vhw81pphb64fzsjvpzsnnyr34ka2fxizfwilnxyjcmpn9360h07";
  }) "nld-eng" "nl_NL";
  eng2nld = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/eng-nld.tar.gz";
    sha256 = "0rcg28ldykv0w2mpxc6g4rqmfs33q7pbvf68ssy1q9gpf6mz7vcl";
  }) "eng-nld" "en_UK";
  eng2rus = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/eng-rus.tar.gz";
    sha256 = "15409ivhww1wsfjr05083pv6mg10bak8v5pg1wkiqybk7ck61rry";
  }) "eng-rus" "en_UK";
  fra2eng = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/fra-eng.tar.gz";
    sha256 = "0sdd88s2zs5whiwdf3hd0s4pzzv75sdsccsrm1wxc87l3hjm85z3";
  }) "fra-eng" "fr_FR";
  eng2fra = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/eng-fra.tar.gz";
    sha256 = "0fi6rrnbqnhc6lq8d0nmn30zdqkibrah0mxfg27hsn9z7alwbj3m";
  }) "eng-fra" "en_UK";
  epo2eng = makeDictdDB (fetchurl {
    url = "https://download.freedict.org/dictionaries/epo-eng/1.0.1/freedict-epo-eng-1.0.1.dictd.tar.xz";
    sha256 = "095xwqfc43dnm0g74i83lg03542f064jy2xbn3qnjxiwysz9ksnz";
  }) "epo-eng" "epo-eng" "eo";
  jpn2eng = makeDictdDB (fetchurl {
    url =
      let
        version = "0.1";
      in
      "mirror://sourceforge/freedict/jpn-eng/${version}/freedict-jpn-eng-${version}.dictd.tar.xz";
    sha256 = "sha256-juJBoEq7EztLZzOomc7uoZhXVaQPKoUvIxxPLB0xByc=";
  }) "jpn-eng" "jpn-eng" "ja_JP";
  eng2jpn = makeDictdDB (fetchurl {
    url =
      let
        version = "2022.04.06";
      in
      "https://download.freedict.org/dictionaries/eng-jpn/${version}/freedict-eng-jpn-${version}.dictd.tar.xz";
    sha256 = "sha256-kfRT2kgbV3XKarCr4mqDRT5A1jR8M8APky5M5MFYatE=";
  }) "eng-jpn" "eng-jpn" "en_UK";
  mueller_eng2rus_pkg = makeDictdDB (fetchurl {
    url = "mirror://sourceforge/mueller-dict/mueller-dict-3.1.tar.gz";
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
  wordnet = callPackage ./dictd-wordnet.nix { };
  wiktionary = callPackage ./wiktionary { };
}
