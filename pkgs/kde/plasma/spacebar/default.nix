{
  mkKdeDerivation,
  pkg-config,
  c-ares,
  curl,
  libphonenumber,
  protobuf,
}:
mkKdeDerivation {
  pname = "spacebar";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    c-ares
    curl
    libphonenumber
    protobuf
  ];
}
