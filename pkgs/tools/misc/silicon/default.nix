{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, cmake
, expat
, fira-code
, fontconfig
, freetype
, harfbuzz
, libiconv
, libxcb
, llvmPackages
, python3
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) AppKit CoreText Security;
in
rustPlatform.buildRustPackage rec {
  pname = "silicon";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${version}";
    sha256 = "sha256-RuzaRJr1n21MbHSeHBt8CjEm5AwbDbvX9Nw5PeBTl+w=";
  };

  cargoSha256 = "sha256-q+CoXoNZOxDmEJ+q1vPWxBJsfHQiCxAMlCZo8C49aQA=";

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
