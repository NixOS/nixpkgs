{ stdenv, fetchFromGitHub, cmake, pkgconfig, openssl, libxml2, boost }:

stdenv.mkDerivation rec {
  name = "davix-0.6.4";
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ stdenv cmake openssl libxml2 boost ];

  src = fetchFromGitHub {
    owner = "cern-it-sdc-id";
    repo = "davix";
    rev = "R_0_6_4";
    sha256 = "10hg7rs6aams96d4ghldgkrrnikskdpmn8vy6hj5j0s17a2yms6q";
  };


  meta = with stdenv.lib; {
    description = "Toolkit for Http-based file management";

    longDescription = "Davix is a toolkit designed for file 
    operations with Http based protocols (WebDav, Amazon S3, ...).
    Davix provides an API and a set of command line tools";

    license     = licenses.lgpl2Plus;
    homepage    = http://dmc.web.cern.ch/projects/davix/home;
    maintainers = [ maintainers.adev ];
    platforms   = platforms.all;
  };  
}

