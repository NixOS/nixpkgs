{ lib
, stdenv
, fetchFromGitHub
, meson
, pkg-config
, ninja
, rizin
, openssl
}:

let
  libquickjs = fetchFromGitHub {
    owner = "frida";
    repo = "quickjs";
    rev = "c81f05c9859cea5f83a80057416a0c7affe9b876";
    hash = "sha256-nAws0ae9kAwvCFcw/yR7XRMwU8EbHoq7kp7iBFpZEZc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jsdec";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "jsdec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UuFA0YKH+0n4Ec3CTiSUFlKXMY4k+tooaEFJYrj6Law=";
  };

  postUnpack = ''
    cp -r --no-preserve=mode ${libquickjs} $sourceRoot/subprojects/libquickjs
  '';

  postPatch = ''
    cp subprojects/packagefiles/libquickjs/* subprojects/libquickjs
  '';

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ openssl rizin ];

  meta = with lib; {
    description = "Simple decompiler for Rizin";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.src.rev}";
    license = with licenses; [ asl20 bsd3 mit ];
    maintainers = with maintainers; [ chayleaf ];
  };
})
