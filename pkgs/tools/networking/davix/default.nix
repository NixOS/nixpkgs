{ stdenv, fetchFromGitHub, cmake, pkgconfig, openssl, libxml2, boost }:

stdenv.mkDerivation rec {
  name = "davix-0.4.0";
  buildInputs = [ stdenv pkgconfig cmake openssl libxml2 boost ];

  src = fetchFromGitHub {
    owner = "cern-it-sdc-id";
    repo = "davix";
    rev = "R_0_4_0-1";
    sha256 = "0i6ica7rmpc3hbybjql5mr500cd43w4qzc69cj1djkc6bqqb752v";
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

