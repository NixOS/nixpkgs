{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkg-config, zlib, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "svenstaro";
    repo   = "miniserve";
    rev    = "v${version}";
    sha256 = "0ybxnxjg0vqm4q60z4zjl3hfls0s2rvy44m6jgyhlj1p6cr3dbyw";
  };

  cargoSha256 = "0ypxv9wqcnjxjdrvdparddpssrarnifr43dq7kcr4l3fd1anl40a";

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ cmake pkg-config zlib ];
  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage    = "https://github.com/svenstaro/miniserve";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ nequissimus ];
    platforms   = platforms.linux;
  };
}
