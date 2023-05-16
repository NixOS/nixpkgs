{ lib
, fetchgit
, buildGoModule
, pigeon
}:

buildGoModule rec {
  pname = "verifpal";
<<<<<<< HEAD
  version = "0.27.0";
=======
  version = "0.26.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchgit {
    url = "https://source.symbolic.software/verifpal/verifpal.git";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rihY5p6nJ1PKjI+gn3NNXy+uzeBG2UNyRYy3UjScf2Q=";
  };

  vendorHash = "sha256-XOCRwh2nEIC+GjGwqd7nhGWQD7vBMLEZZ2FNxs0NX+E=";
=======
    sha256 = "sha256-y07RXv2QSyUJpGuFsLJ2sGNo4YzhoCYQr3PkUj4eIOY=";
  };

  vendorSha256 = "sha256-gUpgnd/xiLqRNl1bPzVp+0GM/J5GEx0VhUfo6JsX8N8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pigeon ];

  subPackages = [ "cmd/verifpal" ];

  # goversioninfo is for Windows only and can be skipped during go generate
  preBuild = ''
    substituteInPlace cmd/verifpal/main.go --replace "go:generate goversioninfo" "(disabled goversioninfo)"
    go generate verifpal.com/cmd/verifpal
  '';

  meta = {
    homepage = "https://verifpal.com/";
    description = "Cryptographic protocol analysis for students and engineers";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ gpl3 ];
<<<<<<< HEAD
=======
    platforms = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
