{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, zlib
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "1h4872jb0xz8yzs02q8wfvqrp20y7kdva5ka6bh6nq4jrnnky8zb";
  };

  cargoSha256 = "1vq1rrav9r9z4y0v7hpn0fcq64slq4zrm2pybmnmb7h9nfxxyr6k";

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ pkg-config zlib ];
  buildInputs = if stdenv.isDarwin then [ Security ] else [ openssl ];

  meta = with stdenv.lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage = "https://github.com/svenstaro/miniserve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nequissimus zowoq ];
    platforms = platforms.unix;
  };
}
