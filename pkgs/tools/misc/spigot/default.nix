{ lib
, stdenv
, fetchurl
, cmake
, gmp
, halibut
, ncurses
, perl
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "spigot";
  version = "20220606.eb585f8";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/spigot-${finalAttrs.version}.tar.gz";
    hash = "sha256-JyNNZo/HUPWv5rYtlNYp8Hl0C7i3yxEyKm+77ysN7Ao=";
=======
stdenv.mkDerivation rec {
  pname = "spigot";
  version = "20210527";
  srcVersion = "20210527.7dd3cfd";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/${pname}-${srcVersion}.tar.gz";
    hash = "sha256-EBS3lgfLtsyBQ8mzoJPyZhRBJNmkVSeF5XecGgcvqtw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    halibut
    perl
  ];

  buildInputs = [
    gmp
    ncurses
  ];

  outputs = [ "out" "man" ];

  strictDeps = true;

<<<<<<< HEAD
  meta = {
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    description = "A command-line exact real calculator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    [ `$out/bin/spigot -b 10 -d 10 e` == "2.7182818284" ] || exit 1
    [ `$out/bin/spigot -b 10 -d 10 pi` == "3.1415926535" ] || exit 1
    [ `$out/bin/spigot -b 10 -d 10 sqrt\(2\)` == "1.4142135623" ] || exit 1

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    description = "A command-line exact real calculator";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres mcbeth ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
