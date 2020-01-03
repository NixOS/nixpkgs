{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner  = "svenstaro";
    repo   = "miniserve";
    rev    = "v${version}";
    sha256 = "06cxkkf3sf84prba65dymr1hg7mwizmsax0dlljh0lcmvlcpzi08";
  };

  cargoSha256 = "046xxxqcf1sdsi9dlilsn0nk36gyca20ck1a70ihj1k9kl7yj8sn";

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [ cmake pkgconfig zlib ];
  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage    = https://github.com/svenstaro/miniserve;
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ nequissimus ];
    platforms   = platforms.linux;
  };
}
