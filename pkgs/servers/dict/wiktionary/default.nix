{ lib, stdenv, fetchurl, python2, dict, glibcLocales }:

stdenv.mkDerivation rec {
  version = "20210201";
  pname = "dict-db-wiktionary";

  src = fetchurl {
    url = "https://dumps.wikimedia.org/enwiktionary/${version}/enwiktionary-${version}-pages-articles.xml.bz2";
    sha256 = "0dc34cbadsg0f6lhfcyx0np7zjnlg6837piqhlvnn0b45xnzn0cs";
  };

  convert = ./wiktionary2dict.py;
  buildInputs = [ python2 dict glibcLocales ];
  builder = ./builder.sh;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "DICT version of English Wiktionary";
    homepage = "http://en.wiktionary.org/";
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
    license = with licenses; [ cc-by-sa-30 fdl11Plus ];
  };
}
