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

  cargoSha256 = "0hz8gqij2g4v3phjyyv019cl3mhcjwlna28886r7kw2y36wfsrkf";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
