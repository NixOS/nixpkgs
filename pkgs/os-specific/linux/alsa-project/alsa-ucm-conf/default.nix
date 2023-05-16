{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "alsa-ucm-conf";
<<<<<<< HEAD
  version = "1.2.9";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    hash = "sha256-N09oM7/XfQpGdeSqK/t53v6FDlpGpdRUKkWWL0ueJyo=";
=======
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    hash = "sha256-/uSnN4MP0l+WnYPaRqKyMb6whu/ZZvzAfSJeeCMmCug=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA Use Case Manager configuration";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.bsd3;
    maintainers = [ maintainers.roastiek ];
    platforms = platforms.linux;
  };
}
