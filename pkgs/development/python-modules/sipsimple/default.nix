{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pkgs
, cython
, dnspython
, dateutil
, xcaplib
, msrplib
, lxml
, python-otr
}:

buildPythonPackage rec {
  pname = "sipsimple";
  version = "3.5.0";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python-sipsimple";
    rev = "release-${version}";
    hash = "sha256-sH4oDMdhh01RTxiUReussWCVvOl3T7DhruthK8GK/M4=";
  };

  preConfigure = ''
    export LD=$CC
  '';

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = with pkgs; [ alsaLib ffmpeg libv4l sqlite libvpx ];
  propagatedBuildInputs = [ cython pkgs.openssl dnspython dateutil xcaplib msrplib lxml python-otr ];

  meta = with lib; {
    description = "SIP SIMPLE implementation for Python";
    homepage = https://sipsimpleclient.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };

}
