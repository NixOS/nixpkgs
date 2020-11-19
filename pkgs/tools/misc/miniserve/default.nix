{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, zlib
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "17m0h0ib7fl0kijagcwdcnvrdcb6z3knix9dl17abg5ivbvkwz8q";
  };

  cargoSha256 = "0ddc8b9wph4r1qcy24p8yiaq9s2knii0d7dh0w0qnzrn6cmm17dg";

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
