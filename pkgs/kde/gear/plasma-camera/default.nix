{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
  qtsensors,
  exiv2,
  libcamera,
}:
mkKdeDerivation {
  pname = "plasma-camera";

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    qtmultimedia
    qtsensors

    exiv2
    libcamera
  ];
}
