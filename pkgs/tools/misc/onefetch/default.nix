{ fetchFromGitHub
, rustPlatform
, lib
, stdenv
, cmake
, pkg-config
, zstd
, CoreFoundation
, libiconv
, libresolv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ydRdnzOI9syfF2ox9vHA9Q0j8C7ZNb0b7CJfqUprPA0=";
  };

  cargoSha256 = "sha256-rZC1CAEWx8l1EQNRs1KAfVgGgBut1hxg6Ug4780O3dw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation libiconv libresolv Security ];

  checkInputs = [
    cmake
  ];

  checkFlags = [
    "--skip=info::tests::test_style_subtitle"
  ];

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kloenk SuperSandro2000 ];
  };
}
