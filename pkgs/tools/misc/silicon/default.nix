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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${version}";
    sha256 = "1avdzs3v6k4jhkadm8i8dlwg0iffqd99xqpi53smd0zgwks744l5";
  };

  cargoSha256 = "0bdb4nadrms5jq3s8pby2qfky7112ynd7vd6mw720mshqklk5zyb";

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
