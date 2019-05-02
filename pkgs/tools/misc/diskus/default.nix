{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  name = "diskus-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "v${version}";
    sha256 = "18scxspi5ncags8bnxq4ah9w8hrlwwlgpq7q9qfh4d81asmbyr8n";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1syrmm5qpz7d1h17xpw1wa3d2snaz9n7d1avsjp7xz8s2qcx1wdc";

  meta = with stdenv.lib; {
    description = "A minimal, fast alternative to 'du -sh'";
    homepage = https://github.com/sharkdp/diskus;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.fuerbringer ];
    platforms = platforms.unix;
  };
}
