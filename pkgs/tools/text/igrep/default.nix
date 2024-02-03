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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    rev = "v${version}";
    hash = "sha256-L5mHuglU0CvTi02pbR8xfezBoH8L/DS+7jgvYvb4yro=";
  };

  cargoHash = "sha256-k63tu5Ffus4z0yd8vQ79q4+tokWAXD05Pvv9JByfnDg=";

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
