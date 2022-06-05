{ lib
, stdenv
, fetchFromGitHub
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "uhubctl";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "mvp";
    repo = "uhubctl";
    rev = "v${version}";
    sha256 = "sha256-F3fOoZYnfIWMrESyVJ/9z6Vou1279avhs600rQayUVA=";
  };

  buildInputs = [ libusb1 ];

  installFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ prusnak ];
    platforms = with platforms; linux ++ darwin;
  };
}
