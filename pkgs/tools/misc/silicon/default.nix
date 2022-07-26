{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, cmake
, llvmPackages
, expat
, freetype
, libxcb
, python3
, libiconv
, AppKit
, CoreText
, Security
, fira-code
}:

rustPlatform.buildRustPackage rec {
  pname = "silicon";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${version}";
    sha256 = "sha256-yhs9BEMMFUtptd0cLsaUW02QZVhztvn8cB0nUqPnO+Y=";
  };

  cargoSha256 = "sha256-tj5HPE9EGC7JQ3dyeMPPI0/3r/idrShqfbpnVuaEtDk=";

  buildInputs = [ llvmPackages.libclang expat freetype fira-code ]
    ++ lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ libiconv AppKit CoreText Security ];

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optionals stdenv.isLinux [ python3 ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  meta = with lib; {
    description = "Create beautiful image of your source code";
    homepage = "https://github.com/Aloxaf/silicon";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs ];
  };
}
