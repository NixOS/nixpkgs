{ lib
, derivationWithMeta
, kaem-unwrapped
, mescc-tools
, src
, version
<<<<<<< HEAD
, platforms
, m2libcArch
, m2libcOS
}:
derivationWithMeta {
  inherit version src mescc-tools m2libcArch m2libcOS;
=======
}:
derivationWithMeta {
  inherit version src mescc-tools;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "mescc-tools-extra";
  builder = kaem-unwrapped;
  args = [
    "--verbose"
    "--strict"
    "--file"
    ./build.kaem
  ];

<<<<<<< HEAD
=======
  ARCH = "x86";
  OPERATING_SYSTEM = "linux";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools-extra";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = teams.minimal-bootstrap.members;
    inherit platforms;
=======
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
