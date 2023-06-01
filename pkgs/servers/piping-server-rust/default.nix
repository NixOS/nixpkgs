{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "piping-server-rust";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "nwtgck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cWBNO9V9DMbEhkjG8g/iswV04DeYh3tXv0+1hB/pf64=";
  };

  cargoSha256 = "sha256-jZio6y2m14tVi3nTQqh+8W3hxft5PfAIWm2XpuyCKDU=";

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
