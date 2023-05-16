{ lib, stdenv, fetchFromGitHub, gtk3, libdivsufsort, pkg-config, wrapGAppsHook }:

stdenv.mkDerivation {
  pname = "flips";
<<<<<<< HEAD
  version = "unstable-2023-03-15";
=======
  version = "unstable-2021-10-28";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
<<<<<<< HEAD
    rev = "fdd5c6e34285beef5b9be759c9b91390df486c66";
    hash = "sha256-uuHgpt7aWqiMTUILm5tAEGGeZrls3g/DdylYQgsfpTw=";
=======
    rev = "3a8733e74c9bdbb6b89da2b45913a0be3d0e1866";
    sha256 = "1jik580mz2spik5mgh60h93ryaj5x8dffncnr1lwija0v803xld7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ gtk3 libdivsufsort ];
  patches = [ ./use-system-libdivsufsort.patch ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildPhase = ''
    runHook preBuild
    ./make.sh
    runHook postBuild
  '';

  meta = with lib; {
    description = "A patcher for IPS and BPS files";
    homepage = "https://github.com/Alcaro/Flips";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.xfix ];
    platforms = platforms.linux;
  };
}
