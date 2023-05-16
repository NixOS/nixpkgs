{ lib
, derivationWithMeta
<<<<<<< HEAD
, hostPlatform
, src
, version
, platforms
, stage0Arch
}:

let
  hash = {
    "x86"   = "sha256-QU3RPGy51W7M2xnfFY1IqruKzusrSLU+L190ztN6JW8=";
    "AMD64" = "sha256-RCgK9oZRDQUiWLVkcIBSR2HeoB+Bh0czthrpjFEkCaY=";
  }.${stage0Arch} or (throw "Unsupported system: ${hostPlatform.system}");

  # Pinned from https://github.com/oriansj/stage0-posix/commit/3189b5f325b7ef8b88e3edec7c1cde4fce73c76c
  # This 256 byte seed is the only pre-compiled binary in the bootstrap chain.
  hex0-seed = import <nix/fetchurl.nix> {
    name = "hex0-seed";
    url = "https://github.com/oriansj/bootstrap-seeds/raw/b1263ff14a17835f4d12539226208c426ced4fba/POSIX/${stage0Arch}/hex0-seed";
    executable = true;
    inherit hash;
  };
in
=======
, hex0-seed
, src
, version
}:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
derivationWithMeta {
  inherit version;
  pname = "hex0";
  builder = hex0-seed;
  args = [
<<<<<<< HEAD
    "${src}/${stage0Arch}/hex0_${stage0Arch}.hex0"
=======
    "${src}/bootstrap-seeds/POSIX/x86/hex0_x86.hex0"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    (placeholder "out")
  ];

  meta = with lib; {
    description = "Minimal assembler for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = teams.minimal-bootstrap.members;
    inherit platforms;
  };

  passthru = { inherit hex0-seed; };

  # Ensure the untrusted hex0-seed binary produces a known-good hex0
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = hash;
=======
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };

  # Ensure the untrusted hex0-seed binary produces a known-good hex0
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-QU3RPGy51W7M2xnfFY1IqruKzusrSLU+L190ztN6JW8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
