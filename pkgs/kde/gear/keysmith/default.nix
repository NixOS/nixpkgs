{
  mkKdeDerivation,
  qtsvg,
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
    libsodium
  ];
  meta.mainProgram = "keysmith";
}
