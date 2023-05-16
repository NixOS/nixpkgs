{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "opengrok";
<<<<<<< HEAD
  version = "1.12.14";
=======
  version = "1.12.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # binary distribution
  src = fetchurl {
    url = "https://github.com/oracle/opengrok/releases/download/${version}/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    hash = "sha256-4v+fDmDnmoAZimf63nSCqUp0y+a5UKQBxNWSNp64XE4=";
=======
    hash = "sha256-m8yD/VEDBE2yfdNiBMhmSELp+Yy//+bTzXqBMGcVeEI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a * $out/
    makeWrapper ${jre}/bin/java $out/bin/opengrok \
      --add-flags "-jar $out/lib/opengrok.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Source code search and cross reference engine";
    homepage = "https://opengrok.github.io/OpenGrok/";
<<<<<<< HEAD
    changelog = "https://github.com/oracle/opengrok/releases/tag/${version}";
    license = licenses.cddl;
    maintainers = [ ];
    platforms = platforms.all;
=======
    license = licenses.cddl;
    maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
