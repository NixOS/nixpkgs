{ stdenv
, lib
, fetchFromGitHub
, jdk
/*
 * jPSXdec needs to be built with no later than JDK8, but
 * should be run with the latest to get HiDPI fixes, etc.
 */
, jre ? jdk
, ant
, unoconv
, makeWrapper
, makeDesktopItem
}:
let
  pname = "jpsxdec";
  version = "1.05";

  description = "Cross-platform PlayStation 1 audio and video converter";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = description;
    desktopName = "jPSXdec";
    categories = [ "AudioVideo" "Utility" ];
  };
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "m35";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wnfvvcyldf699b08lzlc0gshl7rn09a6q4i7jmr41izlcdszdbz";
  };

  nativeBuildInputs = [ ant jdk unoconv makeWrapper ];
  buildInputs = [ jre ];

  patches = [
    ./0001-jpsxdec-hackfix-build-with-newer-JDKs.patch
  ];

  buildPhase = ''
    runHook preBuild

    cd jpsxdec
    mkdir -p _ant/release/doc/
    unoconv -d document -f pdf -o _ant/release/doc/jPSXdec-manual.pdf doc/jPSXdec-manual.odt

    ant release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/pixmaps}
    mv _ant/release $out/jpsxdec

    makeWrapper ${jre}/bin/java $out/bin/jpsxdec \
      --add-flags "-jar $out/jpsxdec/jpsxdec.jar"

    cp ${src}/jpsxdec/src/jpsxdec/gui/icon48.png $out/share/pixmaps/${pname}.png
    ln -s ${desktopItem}/share/applications $out/share

    runHook postInstall
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://jpsxdec.blogspot.com/";
    platforms = platforms.all;
    license = {
      url = "https://raw.githubusercontent.com/m35/jpsxdec/readme/.github/LICENSE.md";
      free = true;
    };
    maintainers = with maintainers; [ zane ];
  };
}
