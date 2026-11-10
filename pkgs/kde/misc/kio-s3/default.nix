{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  aws-sdk-cpp,
  kcmutils,
}:
let
  aws-sdk-cpp-s3 = aws-sdk-cpp.override { apis = [ "s3" ]; };
in
mkKdeDerivation rec {
  pname = "kio-s3";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://kde/stable/kio-s3/kio-s3-${version}.tar.xz";
    hash = "sha256-zixxrZm1U6iaCyZeGBe1lP9ojDqd2qOaekkEa6dyEao=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    aws-sdk-cpp-s3
    kcmutils
  ];

  meta = {
    license = with lib.licenses; [
      bsd3
      cc-by-10
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ daroche ];
  };
}
