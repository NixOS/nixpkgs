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
  version = "3.4.2";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python-sipsimple";
    rev = "release-${version}";
    sha256 = "094xf343d6zjhg9jwbm3dr74zq264cyqnn22byvm2m88lnagmhmr";
  };

  preConfigure = ''
    chmod +x ./deps/pjsip/configure ./deps/pjsip/aconfigure
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
