{ fetchFromGitHub
, rustPlatform
, lib
, stdenv
, pkg-config
, zstd
, CoreFoundation
, libiconv
, libresolv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nSvqAXzA/4CSnOMCZri2ks58bW+9v+SoyIIzb+K5S88=";
  };

  cargoPatches = [
    # enable pkg-config feature of zstd
    ./zstd-pkg-config.patch
  ];

  cargoSha256 = "sha256-uSef6x5QkXKwajglbwyoIsUFGbz0zntVM1ko0FZqnck=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kloenk SuperSandro2000 ];
  };
}
