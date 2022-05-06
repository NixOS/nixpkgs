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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    rev = "v${version}";
    sha256 = "sha256-mJtxqwbqofiDuiGokn24qdnck27w7w/3A5mdqZIU88U=";
  };

  cargoSha256 = "sha256-ikU4SRLu7PQGbidPmf2W39e3sE8QY8YMU6Q0eWhgvLM=";

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
