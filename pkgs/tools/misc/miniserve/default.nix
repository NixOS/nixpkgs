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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "sha256-hTNwEspM1qlQkC6lD7N947tvS7O7RCIUYACvj4KYsAY=";
  };

  cargoSha256 = "sha256-7G+h+g00T/aJ1cQ1SChxy8dq3CWWdHlx5DAH77xM9Oc=";

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
