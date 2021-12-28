{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "oonf-olsrd2";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "OLSR";
    repo = "OONF";
    rev = "v${version}";
    hash = "sha256-7EH2K7gaBGD95WFlG6RRhKEWJm91Xv2GOHYQjZWuzl0=";
  };

  cmakeFlags = [
    "-DOONF_NO_WERROR=yes"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "An adhoc wireless mesh routing daemon";
    license = licenses.bsd3;
    homepage = "http://olsr.org/";
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
