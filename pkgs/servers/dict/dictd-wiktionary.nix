{stdenv, fetchurl, python, dict, glibcLocales, writeScript}:

stdenv.mkDerivation rec {
  version = "20121021";
  name = "dict-db-wiktionary-${version}";
  data = fetchurl {
    url = "http://dumps.wikimedia.org/enwiktionary/${version}/enwiktionary-${version}-pages-articles.xml.bz2";
    sha256 = "1i4xwdpc2bx58495iy62iz0kn50c3qmnh4qribi82f2rd4qkfjd2";
  };

  convert = ./wiktionary2dict.py;
  buildInputs = [python dict glibcLocales];

  builder = writeScript "wiktionary-builder.sh" ''
    source $stdenv/setup

    ensureDir $out/share/dictd/
    cd $out/share/dictd

    export LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive
    python -O ${convert} ${data}
    dictzip wiktionary-en.dict
    echo en_US.UTF-8 > locale
  '';

  meta = {
    description = "DICT version of English Wiktionary";
    homepage = http://en.wiktionary.org/;
    maintainers = [ stdenv.lib.maintainers.mornfall ];
    platforms = stdenv.lib.platforms.all;
  };
}
