{ lib, fetchFromGitHub, rustPlatform, stdenv, python3, AppKit, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "jless";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "PaulJuliusMartinez";
    repo = "jless";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-76oFPUWROX389U8DeMjle/GkdItu+0eYxZkt1c6l0V4=";
  };

  cargoHash = "sha256-sas94liAOSIirIJGdexdApXic2gWIBDT4uJFRM3qMw0=";
=======
    sha256 = "sha256-NB/s29M46mVhTsJWFYnBgJjSjUVbfdmuz69VdpVuR7c=";
  };

  cargoSha256 = "sha256-cPj9cTRhWK/YU8Cae63p4Vm5ohB1IfGL5fu7yyFGSXA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = lib.optionals stdenv.isLinux [ python3 ];

  buildInputs = [ ]
    ++ lib.optionals stdenv.isDarwin [ AppKit ]
    ++ lib.optionals stdenv.isLinux [ libxcb ];

  meta = with lib; {
    description = "A command-line pager for JSON data";
    homepage = "https://jless.io";
<<<<<<< HEAD
    changelog = "https://github.com/PaulJuliusMartinez/jless/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda jfchevrette ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ jfchevrette ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
