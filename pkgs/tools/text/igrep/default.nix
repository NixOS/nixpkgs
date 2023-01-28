{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
, testers
, igrep
}:

rustPlatform.buildRustPackage rec {
  pname = "igrep";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    rev = "v${version}";
    sha256 = "sha256-pXgmbSmOLeAtI7pP0X9go4KnlLv4RChBQNCPYeG4Q84=";
  };

  cargoHash = "sha256-n1AVD6PuZFdZbTuGxNHvR6ngoVmSAixabcJl6nIcyP0=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  passthru.tests = {
    version = testers.testVersion { package = igrep; command = "ig --version"; };
  };

  meta = with lib; {
    description = "Interactive Grep";
    homepage = "https://github.com/konradsz/igrep";
    changelog = "https://github.com/konradsz/igrep/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "ig";
  };
}
