{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, zlib
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "sha256-1LyDwQWC8cb3Sq8lZ9eDpZMcu5/yh0BJFuOWQ3iTtpY=";
  };

  cargoSha256 = "sha256-11aP0/p9wC9o1KuM+CLAuHhZxuYff6nvJPj0/yjb1+E=";

  nativeBuildInputs = [ pkg-config zlib ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlags = [ "--skip=cant_navigate_up_the_root" ];

  meta = with lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage = "https://github.com/svenstaro/miniserve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zowoq ];
    platforms = platforms.unix;
  };
}
