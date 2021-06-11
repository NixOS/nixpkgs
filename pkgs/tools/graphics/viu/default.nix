{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "1n1qwlh1zinq5ngx04cvs69z8zr12yywr70vbrc946kbh4hx6pk9";
  };

  # tests need an interactive terminal
  doCheck = false;

  cargoSha256 = "0s6i42n4jivzj4ad62r7nc6ailydy686ivszcd6cj5f4dinsbgq3";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
