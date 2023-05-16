{ lib, stdenv, fetchFromGitHub, python3 }:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "woof";
  version = "2022-01-13";
=======
stdenv.mkDerivation rec {
  version = "2020-12-17";
  pname = "woof";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "simon-budig";
    repo = "woof";
<<<<<<< HEAD
    rev = "f51e9db264118d4cbcd839348c4a6223fda49813";
    sha256 = "sha256-tk55q2Ew2mZkQtkxjWCuNgt9t+UbjH4llIJ42IruqGY=";
=======
    rev = "4aab9bca5b80379522ab0bdc5a07e4d652c375c5";
    sha256 = "0ypd2fs8isv6bqmlrdl2djgs5lnk91y1c3rn4ar6sfkpsqp9krjn";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ python3 ];

<<<<<<< HEAD
  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin woof
    runHook postInstall
=======
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/woof $out/bin/woof
    chmod +x $out/bin/woof
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    homepage = "http://www.home.unix-ag.org/simon/woof.html";
    description = "Web Offer One File - Command-line utility to easily exchange files over a local network";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
