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
, fontconfig
, harfbuzz
}:

rustPlatform.buildRustPackage rec {
  pname = "silicon";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${version}";
    sha256 = "sha256-RuzaRJr1n21MbHSeHBt8CjEm5AwbDbvX9Nw5PeBTl+w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pathfinder_simd-0.5.1" = "sha256-jQCa8TpGHLWvDT9kXWmlw51QtpKImPlWi082Va721cE=";
    };
  };

  buildInputs = [ llvmPackages.libclang expat freetype fira-code fontconfig harfbuzz ]
    ++ lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ libiconv AppKit CoreText Security ];

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optionals stdenv.isLinux [ python3 ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Create beautiful image of your source code";
    homepage = "https://github.com/Aloxaf/silicon";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs _0x4A6F ];
  };
}
