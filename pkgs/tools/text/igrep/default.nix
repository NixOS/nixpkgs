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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    rev = "v${version}";
    sha256 = "sha256-g6DY3+HwBNQ+jxByXyTJK5CjAaC48FpmsDf1qGGO/Lk=";
  };

  cargoHash = "sha256-7cSUIwWyWPxFDuRWplidbI93zbBV84T7e4Q//Uwj6N4=";

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
