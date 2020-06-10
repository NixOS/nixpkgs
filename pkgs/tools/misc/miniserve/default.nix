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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "06nrb84xfvx02yc4bjn1szfq3bjy8mqgxwwrjghl7vpcw51qhlk5";
  };

  cargoSha256 = "0mk8hvhjqggfr410yka9ygb41l1bnsizs8py3100xf685yxy5mhl";

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
