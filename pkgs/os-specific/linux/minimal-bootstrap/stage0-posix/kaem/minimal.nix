{ lib
, derivationWithMeta
, src
, hex0
, version
<<<<<<< HEAD
, platforms
, stage0Arch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:
derivationWithMeta {
  inherit version;
  pname = "kaem-minimal";
  builder = hex0;
  args = [
<<<<<<< HEAD
    "${src}/${stage0Arch}/kaem-minimal.hex0"
=======
    "${src}/bootstrap-seeds/POSIX/x86/kaem-minimal.hex0"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    (placeholder "out")
  ];

  meta = with lib; {
    description = "First stage minimal scriptable build tool for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
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

