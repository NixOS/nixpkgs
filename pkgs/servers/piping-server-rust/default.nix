{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "piping-server-rust";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "nwtgck";
    repo = pname;
    rev = "v${version}";
    sha256 = "16jzl0nk14gzb5kvilr17f02b41ma7xwh8y0g42pm9sb7jdbcn7g";
  };

  cargoSha256 = "sha256-SDAxXYX51/4S7zRTdNZK9uSjKHKrAXpDJgRRDyu6qug=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Infinitely transfer between every device over pure HTTP with pipes or browsers";
    homepage = "https://github.com/nwtgck/piping-server-rust";
    changelog = "https://github.com/nwtgck/piping-server-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "piping-server";
  };
}
