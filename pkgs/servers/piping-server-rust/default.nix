{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "piping-server-rust";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "nwtgck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3EDUG9W4WzYk/bjUFIQ7Ho0KR6aMykhyTnWR/+VNxz8=";
  };

  cargoSha256 = "sha256-8xUhYyjc4560PowCRwYeZMUJLhZFTHcMRLe/iQAwaWE=";

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
