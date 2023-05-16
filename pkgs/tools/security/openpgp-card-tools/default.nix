{ lib
, stdenv
, rustPlatform
<<<<<<< HEAD
, fetchFromGitea
=======
, fetchCrate
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, pcsclite
, nettle
, PCSC
, testers
, openpgp-card-tools
}:

rustPlatform.buildRustPackage rec {
  pname = "openpgp-card-tools";
<<<<<<< HEAD
  version = "0.9.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${version}";
    hash = "sha256-ISIABjuh0BC6OUFa5I9Wou+av7Dp4bZH8Aazi6x7cqY=";
  };

  cargoHash = "sha256-+EEpoI9OQvnJR6bVbEuLn3O7w6BchjBzr+oMGsWdP/k=";
=======
  version = "0.9.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-F+j8bK0sBBLWlQzLAcvl6BdiI3Dy8ollwTpL7929nJ8=";
  };

  cargoHash = "sha256-Wn3fXAft+sju8FhX6YFHRvqt815NhTlfhLJarSemvm0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ pcsclite nettle ] ++ lib.optionals stdenv.isDarwin [ PCSC ];

  passthru = {
    tests.version = testers.testVersion {
      package = openpgp-card-tools;
    };
  };

  meta = with lib; {
    description = "CLI tools for OpenPGP cards";
    homepage = "https://gitlab.com/openpgp-card/openpgp-card";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "opgpcard";
  };
}
