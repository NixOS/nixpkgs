{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "simp_le-2016-12-16";

  # kuba/simp_le seems unmaintained
  src = fetchFromGitHub {
    owner = "zenhack";
    repo = "simp_le";
    rev = "63a43b8547cd9fbc87db6bcd9497c6e37f73abef";
    sha256 = "04dr8lvcpi797722lsy06nxhlihrxdqgdy187pg3hl1ki2iq3ixx";
  };

  propagatedBuildInputs = with pythonPackages; [ acme ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner nckx ];
    platforms = platforms.all;
  };
}
