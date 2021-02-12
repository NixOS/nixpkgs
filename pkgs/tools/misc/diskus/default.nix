{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "diskus";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "v${version}";
    sha256 = "087w58q5kd3r23a9qnhqgvq4vhv69b5a6a7n3kh09g5cjszy8s05";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0baaryl994952rdnpqq3gnhcab2mc4b6ls502g4bazjm823inqlh";

  meta = with lib; {
    description = "A minimal, fast alternative to 'du -sh'";
    homepage = "https://github.com/sharkdp/diskus";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.fuerbringer ];
    platforms = platforms.unix;
    longDescription = ''
      diskus is a very simple program that computes the total size of the
      current directory. It is a parallelized version of du -sh.
    '';
  };
}
