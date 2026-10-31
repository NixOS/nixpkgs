{
  mkKdeDerivation,
  qtsvg,
  qtdeclarative,
  shared-mime-info,
  poppler,
  libphonenumber,
  protobuf,
  fetchpatch2,
}:
mkKdeDerivation {
  pname = "kitinerary";

  extraNativeBuildInputs = [ shared-mime-info ];
  extraBuildInputs = [
    qtsvg
    qtdeclarative
    poppler
    libphonenumber
    protobuf
  ];

  patches = [
    # Adapt to Poppler 26.08 API changes (https://invent.kde.org/pim/kitinerary/-/commit/4b045ba2c8b2bda899a7ef77a3a68666d62a8423)
    (fetchpatch2 {
      url = "https://invent.kde.org/pim/kitinerary/-/commit/4b045ba2c8b2bda899a7ef77a3a68666d62a8423.patch";
      hash = "sha256-3K4uaY1z8Iy7jIBwAz883nfZMpdY2ojQOZOcV+HqgGg=";
    })
  ];
}
