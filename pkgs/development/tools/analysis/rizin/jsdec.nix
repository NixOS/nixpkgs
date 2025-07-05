{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  rizin,
  openssl,
}:

let
  version = "0.8.0";

  libquickjs = fetchFromGitHub {
    owner = "quickjs-ng";
    repo = "quickjs";
    tag = "v${version}";
    hash = "sha256-o0Cpy+20EqNdNENaYlasJcKIGU7W4RYBcTMsQwFTUNc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jsdec";
  version = version;

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "jsdec";
    rev = "v${version}";
    hash = "sha256-Xc8FMKSGdjrp288u49R6YC0xiynwHeoZe2P/UqnfsFU=";
  };

  postUnpack = ''
    cp -r --no-preserve=mode ${libquickjs} $sourceRoot/subprojects/libquickjs
  '';

  postPatch = ''
    cp subprojects/packagefiles/libquickjs/* subprojects/libquickjs
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    openssl
    rizin
  ];

  meta = with lib; {
    description = "Simple decompiler for Rizin";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.src.rev}";
    license = with licenses; [
      asl20
      bsd3
      mit
    ];
    maintainers = with maintainers; [ chayleaf ];
  };
})
