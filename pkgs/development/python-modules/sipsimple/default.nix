{ stdenv
, buildPythonPackage
, fetchdarcs
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
  version = "3.1.1";
  disabled = isPy3k;

  src = fetchdarcs {
    url = http://devel.ag-projects.com/repositories/python-sipsimple;
    rev = "release-${version}";
    sha256 = "0jdilm11f5aahxrzrkxrfx9sgjgkbla1r0wayc5dzd2wmjrdjyrg";
  };

  preConfigure = ''
    chmod +x ./deps/pjsip/configure ./deps/pjsip/aconfigure
    export LD=$CC
  '';

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = with pkgs; [ alsaLib ffmpeg libv4l sqlite libvpx ];
  propagatedBuildInputs = [ cython pkgs.openssl dnspython dateutil xcaplib msrplib lxml python-otr ];

  meta = with stdenv.lib; {
    description = "SIP SIMPLE implementation for Python";
    homepage = http://sipsimpleclient.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };

}
