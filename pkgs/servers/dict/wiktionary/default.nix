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
    sha256 = "f37e899a9091a1b01137c7b0f3d58813edf3039e9e94ae656694c88859bbe756";
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

  meta = with lib; {
    description = "DICT version of English Wiktionary";
    homepage = "https://en.wiktionary.org/";
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
    license = with licenses; [
      cc-by-sa-30
      fdl11Plus
    ];
  };
}
