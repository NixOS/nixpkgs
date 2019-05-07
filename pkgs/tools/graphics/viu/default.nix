{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "1j2sr8mhnbyzm168spzr4mk8gkjlfqh993b80sf2zv2sy83p8gfv";
  };

  cargoSha256 = "14pf2xvkk9qqq9qj5agxmfl3npgy6my961yfzv7p977712kdakh3";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
  };
}
