{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "diskus";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "v${version}";
    sha256 = "18scxspi5ncags8bnxq4ah9w8hrlwwlgpq7q9qfh4d81asmbyr8n";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "13d4h6f3idwj2bxafqrjihgwwr8v3k158r7b569jp7q2v1msqqx1";

  meta = with stdenv.lib; {
    description = "A minimal, fast alternative to 'du -sh'";
    homepage = https://github.com/sharkdp/diskus;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.fuerbringer ];
    platforms = platforms.unix;
  };
}
