{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, zlib
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "01nsviw5nc5lb6z3j2yiymiwhiq719nwqpvqbyb5p65s98sph7yh";
  };

  cargoSha256 = "098p4645air5402shqignc57zdm6755shahhby17nqv1s27gfinc";

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ pkg-config zlib ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage = "https://github.com/svenstaro/miniserve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zowoq ];
    platforms = platforms.unix;
  };
}
