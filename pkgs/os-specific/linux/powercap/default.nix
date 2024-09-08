{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "powercap";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "powercap";
    repo = "powercap";
    rev = "v${version}";
    sha256 = "sha256-l+IpFqBnCYUU825++sUPySD/Ku0TEIX2kt+S0Wml6iA=";
  };

  # in master post 0.6.0, see https://github.com/powercap/powercap/issues/8
  patches = [
    (fetchpatch {
      name = "fix-pkg-config.patch";
      url = "https://github.com/powercap/powercap/commit/278dceb51635686e343edfc357b6020533fff299.patch";
      sha256 = "0h62j63xdn0iqyx4xbia6hlmdjn45camb82z4vv6sb37x9sph7rg";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=On"
  ];

  meta = with lib; {
    description = "Tools and library to read/write to the Linux power capping framework (sysfs interface)";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rowanG077 ];
  };
}
