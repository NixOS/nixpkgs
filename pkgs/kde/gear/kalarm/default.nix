{
  mkKdeDerivation,
  pkg-config,
  kauth,
  mpv,
}:
mkKdeDerivation {
  pname = "kalarm";

  extraCmakeFlags = [
    "-DENABLE_LIBVLC=0"
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    kauth
    mpv
  ];
}
