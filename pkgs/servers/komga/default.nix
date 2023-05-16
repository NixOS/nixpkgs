{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
<<<<<<< HEAD
, jdk17_headless
=======
, jdk11_headless
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nixosTests
}:

stdenvNoCC.mkDerivation rec {
  pname = "komga";
<<<<<<< HEAD
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/v${version}/${pname}-${version}.jar";
    sha256 = "sha256-R1weJRQ8DkBbUndGyO8wvFpsI+6OTZ59C8P6EzsMV+E=";
=======
  version = "0.165.0";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/v${version}/${pname}-${version}.jar";
    sha256 = "sha256-J8dpw7GzLJnLiiFSFVCoqZFQ6mI2z0zBZHdbmxMgmf8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
<<<<<<< HEAD
    makeWrapper ${jdk17_headless}/bin/java $out/bin/komga --add-flags "-jar $src"
=======
    makeWrapper ${jdk11_headless}/bin/java $out/bin/komga --add-flags "-jar $src"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  passthru.tests = {
    komga = nixosTests.komga;
  };

  meta = with lib; {
    description = "Free and open source comics/mangas server";
    homepage = "https://komga.org/";
    license = licenses.mit;
<<<<<<< HEAD
    platforms = jdk17_headless.meta.platforms;
=======
    platforms = jdk11_headless.meta.platforms;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ govanify ];
  };

}
