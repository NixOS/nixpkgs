{stdenv, fetchurl, python, dict, glibcLocales, writeScript}:

stdenv.mkDerivation rec {
  version = "20161001";
  pname = "dict-db-wiktionary";
  data = fetchurl {
    url = "http://dumps.wikimedia.org/enwiktionary/${version}/enwiktionary-${version}-pages-articles.xml.bz2";
    sha256 = "0g3k7kxp2nzg0v56i4cz253af3aqvhn1lwkys2fnam51cn3yqm7m";
  };

  convert = ./wiktionary2dict.py;
  buildInputs = [python dict glibcLocales];

  builder = writeScript "wiktionary-builder.sh" ''
    source $stdenv/setup

    mkdir -p $out/share/dictd/
    cd $out/share/dictd

    python -O ${convert} ${data}
    dictzip wiktionary-en.dict
    echo en_US.UTF-8 > locale
  '';

  meta = {
    description = "DICT version of English Wiktionary";
    homepage = http://en.wiktionary.org/;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
