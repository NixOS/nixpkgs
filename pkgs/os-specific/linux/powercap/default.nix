{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "powercap";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "powercap";
    repo = "powercap";
    rev = "v${version}";
    sha256 = "sha256-VvepbABc7daRE0/sJqsCb+m2my8O3B1ICXywBqsjSO8=";
  };

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
