{
  mkKdeDerivation,
  qtsvg,
  pkg-config,
  libsodium,
}:
mkKdeDerivation {
  pname = "keysmith";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtsvg libsodium];
  meta.mainProgram = "keysmith";
}
