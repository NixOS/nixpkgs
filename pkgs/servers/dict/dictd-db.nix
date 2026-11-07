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
        description = "Dictd-db dictionary for dictd";
        platforms = lib.platforms.linux;
      };
    };
in
rec {
  deu2eng = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/deu-eng.tar.gz";
    hash = "sha256-K+u/9QpME+ig88BFZuPNoJfJHXs6vmUJ0sWRR8CGGTc=";
  }) "deu-eng" "de_DE";
  eng2deu = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/eng-deu.tar.gz";
    hash = "sha256-eZxP2756odRHNiX/AxwgBKGC1PtQDudiOGAoLc4VoQc=";
  }) "eng-deu" "en_EN";
  nld2eng = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/nld-eng.tar.gz";
    hash = "sha256-B0BgRrK3Mum7pZG7H7sTapKRvbX63y31d8QseG9AHO4=";
  }) "nld-eng" "nl_NL";
  eng2nld = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/eng-nld.tar.gz";
    hash = "sha256-lO3zq3H3JRy81si4ve7BY2hXcSbPsH6r4GBP3ygSj2U=";
  }) "eng-nld" "en_UK";
  eng2rus = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/eng-rus.tar.gz";
    hash = "sha256-PudgJjtzeRwnD++WjaZaILxq9h0IFJCl0zxwDndMgJQ=";
  }) "eng-rus" "en_UK";
  fra2eng = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/fra-eng.tar.gz";
    hash = "sha256-4xdUJRz0INZ5qFkzppsuZ/9/iQYNDtd4hLzoLzRCrWk=";
  }) "fra-eng" "fr_FR";
  eng2fra = makeDictdDBFreedict (fetchurl {
    url = "mirror://sourceforge/freedict/eng-fra.tar.gz";
    hash = "sha256-dcjFqTo/WQ2PeK5XAFVeceL2wbDVgoYwNQxavGzOJjo=";
  }) "eng-fra" "en_UK";
  epo2eng = makeDictdDB (fetchurl {
    url = "https://download.freedict.org/dictionaries/epo-eng/1.0.1/freedict-epo-eng-1.0.1.dictd.tar.xz";
    hash = "sha256-3+qZvvY8dmnxsKsLL4kBTpAywKMDRXIeqLYNwhzmvSQ=";
  }) "epo-eng" "epo-eng" "eo";
  jpn2eng = makeDictdDB (fetchurl {
    url =
      let
        version = "0.1";
      in
      "mirror://sourceforge/freedict/jpn-eng/${version}/freedict-jpn-eng-${version}.dictd.tar.xz";
    hash = "sha256-juJBoEq7EztLZzOomc7uoZhXVaQPKoUvIxxPLB0xByc=";
  }) "jpn-eng" "jpn-eng" "ja_JP";
  eng2jpn = makeDictdDB (fetchurl {
    url =
      let
        version = "2022.04.06";
      in
      "https://download.freedict.org/dictionaries/eng-jpn/${version}/freedict-eng-jpn-${version}.dictd.tar.xz";
    hash = "sha256-kfRT2kgbV3XKarCr4mqDRT5A1jR8M8APky5M5MFYatE=";
  }) "eng-jpn" "eng-jpn" "en_UK";
  mueller_eng2rus_pkg = makeDictdDB (fetchurl {
    url = "mirror://sourceforge/mueller-dict/mueller-dict-3.1.tar.gz";
    hash = "sha256-uDp+/yi89/3qKxZDKw9qbe3+BHRPLtwnRIvVbX/vJRM=";
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
