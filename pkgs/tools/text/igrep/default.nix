{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
, testVersion
, igrep
}:

rustPlatform.buildRustPackage rec {
  pname = "igrep";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "konradsz";
    repo = "igrep";
    rev = "v${version}";
    sha256 = "sha256-CH0wf9EhNnfi93W/4IJf6bPqU4pgw6Q9965Wjln9pso=";
  };

  cargoSha256 = "sha256-VnZuRLBt/Q+D89+jKm0rak+ID5oNbvN1k8or3pYzfIM=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  passthru.tests = {
    version = testVersion { package = igrep; command = "ig --version"; };
  };

  meta = with lib; {
    description = "Interactive Grep";
    homepage = "https://github.com/konradsz/igrep";
    changelog = "https://github.com/konradsz/igrep/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
