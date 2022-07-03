{ lib, stdenv, fetchurl, python2, dict, glibcLocales }:

stdenv.mkDerivation rec {
  pname = "dict-db-wiktionary";
  version = "20220420";

  src = fetchurl {
    url = "https://dumps.wikimedia.org/enwiktionary/${version}/enwiktionary-${version}-pages-articles.xml.bz2";
    sha256 = "qsha26LL2513SDtriE/0zdPX1zlnpzk1KKk+R9dSdew=";
  };

  # script in nixpkgs does not support python2
  nativeBuildInputs = [ python2 dict glibcLocales ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/dictd/
    cd $out/share/dictd

    ${python2.interpreter} -O ${./wiktionary2dict.py} "${src}"
    dictzip wiktionary-en.dict
    echo en_US.UTF-8 > locale
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "DICT version of English Wiktionary";
    homepage = "https://en.wiktionary.org/";
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
    license = with licenses; [ cc-by-sa-30 fdl11Plus ];
  };
}
