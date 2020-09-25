{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, zlib
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "1abmg2zk1qipqdl1yfj8ibm1w8n7fazxqccsg1gq4xzlhhfp3m2l";
  };

  cargoSha256 = "0l750067x8k92ngg32bb8mnbq09aj65sdnpzdhij9n1mh90rkck9";

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ pkg-config zlib ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage = "https://github.com/svenstaro/miniserve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nequissimus zowoq ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # https://github.com/NixOS/nixpkgs/pull/98181
  };
}
