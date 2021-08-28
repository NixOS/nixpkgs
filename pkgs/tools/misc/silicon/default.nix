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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${version}";
    sha256 = "sha256-k+p8AEEL1BBJTmPc58QoIk7EOzu8QKdG00RQ58EN3bg=";
  };

  cargoSha256 = "sha256-vpegobS7lpRkt/oZePW9WggYeg0JXDte8fQP/bf7oAI=";

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
