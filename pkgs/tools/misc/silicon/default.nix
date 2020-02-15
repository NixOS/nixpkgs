{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkgconfig
, cmake
, llvmPackages
, expat
, freetype
, libxcb
, python3
, AppKit
, CoreText
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "silicon";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${version}";
    sha256 = "0j211qrkwgll7rm15dk4fcazmxkcqk2zah0qg2s3y0k7cx65bcxy";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "11b9i1aa36wc7mg2lsvmkiisl23mjkg02xcvlb7zdangwzbv13sq";

  buildInputs = [ llvmPackages.libclang expat freetype ]
    ++ lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit CoreText Security ];

  nativeBuildInputs = [ cmake pkgconfig ]
    ++ lib.optionals stdenv.isLinux [ python3 ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  meta = with lib; {
    description = "Create beautiful image of your source code.";
    homepage = "https://github.com/Aloxaf/silicon";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs ];
    platforms = platforms.all;
  };
}
