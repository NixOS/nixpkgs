{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
<<<<<<< HEAD
  version = "0.47.5";
=======
  version = "0.47.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-kAXzBJMAxHjZSK6lbpF+/27n9CGvq7x6Ay2TaFYgQSU=";
  };

  cargoHash = "sha256-681ZFS8dtn815VYdFwPEJXnuMGTycSuRPDxmj1kN3rs=";
=======
    sha256 = "sha256-CW7rPylP3Swyv+rxwbeooUC6XEkmGCCpGEqM7zNG1b4=";
  };

  cargoHash = "sha256-yO0wcijM8q81g/HSmouHduUb12kaNVRIv4pECs8XyFw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
