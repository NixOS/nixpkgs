{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "powercap";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "powercap";
    repo = "powercap";
    rev = "v${version}";
    sha256 = "0f1sg1zsskcfralg9khwq7lmz25gvnyknza3bb0hmh1a9lw0jhdn";
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
