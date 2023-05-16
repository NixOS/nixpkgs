{ stdenv, lib, fetchFromGitHub, cmake, bash-completion, pkg-config, libconfig
, asciidoc
, libusbgx
}:
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "gt";
  version = "unstable-2022-05-08";

  src = fetchFromGitHub {
    owner = "linux-usb-gadgets";
    repo = "gt";
    rev = "7f9c45d98425a27444e49606ce3cf375e6164e8e";
    sha256 = "sha256-km4U+t4Id2AZx6GpH24p2WNmvV5RVjJ14sy8tWLCQsk=";
  };

<<<<<<< HEAD
  sourceRoot = "${finalAttrs.src.name}/source";
=======
  sourceRoot = "source/source";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preConfigure = ''
    cmakeFlagsArray+=("-DBASH_COMPLETION_COMPLETIONSDIR=$out/share/bash-completions/completions")
  '';

  nativeBuildInputs = [ cmake pkg-config asciidoc ];

  buildInputs = [ bash-completion libconfig libusbgx];

  meta = {
    description = "Linux command line tool for setting up USB gadgets using configfs";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ lheckemann ];
    platforms = lib.platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
