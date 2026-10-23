{
  lib,
  stdenv,
  fetchurl,
  python3,
  dict,
  glibcLocales,
  libfaketime,
}:

stdenv.mkDerivation rec {
  pname = "dict-db-wiktionary";
  version = "20240901";

  src = fetchurl {
    url = "https://dumps.wikimedia.org/enwiktionary/${version}/enwiktionary-${version}-pages-articles.xml.bz2";
    hash = "sha256-836JmpCRobARN8ew89WIE+3zA56elK5lZpTIiFm751Y=";
  };

  nativeBuildInputs = [
    python3
    dict
    glibcLocales
    libfaketime
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/dictd/
    cd $out/share/dictd

    source_date=$(date --utc --date=@$SOURCE_DATE_EPOCH "+%F %T")
    faketime -f "$source_date" ${python3.interpreter} -O ${./wiktionary2dict.py} "${src}"
    faketime -f "$source_date" dictzip wiktionary-en.dict
    echo en_US.UTF-8 > locale
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "DICT version of English Wiktionary";
    homepage = "https://en.wiktionary.org/";
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      cc-by-sa-30
      fdl11Plus
    ];
  };
}
