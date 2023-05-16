{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go365";
<<<<<<< HEAD
  version = "2.0";
=======
  version = "1.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "optiv";
    repo = "Go365";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-jmsbZrqc6XogUhuEWcU59v88id2uLqN/68URwylzWZI=";
  };

  vendorHash = "sha256-Io+69kIW4DV2EkA73pjaTcTRbDSYBf61R7F+141Jojs=";
=======
    rev = version;
    sha256 = "0dh89hf00fr62gjdw2lb1ncdxd26nvlsh2s0i6981bp8xfg2pk5r";
  };

  vendorSha256 = "0fx2966xfzmi8yszw1cq6ind3i2dvacdwfs029v3bq0n8bvbm3r2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    mv $out/bin/Go365 $out/bin/$pname
  '';

  meta = with lib; {
    description = "Office 365 enumeration tool";
    homepage = "https://github.com/optiv/Go365";
<<<<<<< HEAD
    changelog = "https://github.com/optiv/Go365/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "Go365";
  };
}
