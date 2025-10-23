{
  mkKdeDerivation,
  qtsvg,
  kirigami-addons,
  pkg-config,
  libsodium,
}:
mkKdeDerivation {
  pname = "keysmith";

  patches = [
    ./optional-runtime-dependencies.patch
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtsvg
    kirigami-addons
    libsodium
  ];
  meta.mainProgram = "keysmith";
}
