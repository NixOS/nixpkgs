<<<<<<< HEAD
{ lib, stdenv, fetchurl, python3, dict, glibcLocales, libfaketime }:
=======
{ lib, stdenv, fetchurl, python3, dict, glibcLocales }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "dict-db-wiktionary";
  version = "20220420";

  src = fetchurl {
    url = "https://dumps.wikimedia.org/enwiktionary/${version}/enwiktionary-${version}-pages-articles.xml.bz2";
    sha256 = "qsha26LL2513SDtriE/0zdPX1zlnpzk1KKk+R9dSdew=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ python3 dict glibcLocales libfaketime ];
=======
  nativeBuildInputs = [ python3 dict glibcLocales ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/dictd/
    cd $out/share/dictd

<<<<<<< HEAD
    source_date=$(date --utc --date=@$SOURCE_DATE_EPOCH "+%F %T")
    faketime -f "$source_date" ${python3.interpreter} -O ${./wiktionary2dict.py} "${src}"
    faketime -f "$source_date" dictzip wiktionary-en.dict
=======
    ${python3.interpreter} -O ${./wiktionary2dict.py} "${src}"
    dictzip wiktionary-en.dict
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
