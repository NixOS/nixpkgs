{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "piping-server-rust";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "nwtgck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ON3/GaDwQ9DtApRZuYClZWzFhmiLi988jIBvl0DgYSM=";
  };

  cargoSha256 = "sha256-rc3VTJllDu4oIFcswCNUJejJHzC2PoJJV9EU5fOC7fQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with lib; {
    description = "Infinitely transfer between every device over pure HTTP with pipes or browsers";
    homepage = "https://github.com/nwtgck/piping-server-rust";
    changelog = "https://github.com/nwtgck/piping-server-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "piping-server";
  };
}
