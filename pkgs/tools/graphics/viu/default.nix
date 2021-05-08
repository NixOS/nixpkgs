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

  cargoSha256 = "0bdjfcyx2cwz68gcx0393h4ysccarfp02pvvp0a5xgkq11bad0r0";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
