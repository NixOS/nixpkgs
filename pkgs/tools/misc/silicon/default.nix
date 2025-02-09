{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
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
    hash = "sha256-RuzaRJr1n21MbHSeHBt8CjEm5AwbDbvX9Nw5PeBTl+w=";
  };

  patches = [
   # fix build on aarch64-linux, see https://github.com/Aloxaf/silicon/pull/210
    (fetchpatch {
      url = "https://github.com/Aloxaf/silicon/commit/f666c95d3dab85a81d60067e2f25d29ee8ab59e7.patch";
      hash = "sha256-L6tF9ndC38yVn5ZNof1TMxSImmaqZ6bJ/NYhb0Ebji4=";
    })
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pathfinder_simd-0.5.1" = "sha256-jQCa8TpGHLWvDT9kXWmlw51QtpKImPlWi082Va721cE=";
    };
  };

  buildInputs = [ expat freetype fira-code fontconfig harfbuzz ]
    ++ lib.optionals stdenv.isLinux [ libxcb ]
    ++ lib.optionals stdenv.isDarwin [ libiconv AppKit CoreText Security ];

  nativeBuildInputs = [ cmake pkg-config rustPlatform.bindgenHook ]
    ++ lib.optionals stdenv.isLinux [ python3 ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Create beautiful image of your source code";
    homepage = "https://github.com/Aloxaf/silicon";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs _0x4A6F ];
    mainProgram = "silicon";
  };
}
