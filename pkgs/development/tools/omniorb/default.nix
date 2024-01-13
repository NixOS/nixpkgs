{ lib
, stdenv
, fetchurl
, pkg-config
, python3
}:

stdenv.mkDerivation rec {

  pname = "omniorb";
  version = "4.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/omniorb/omniORB/omniORB-${version}/omniORB-${version}.tar.bz2";
    hash = "sha256-D0K8Prc3yuaA2vqFs645WOn1ajeRLF+2uHWTP4+3OQ0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ python3 ];

  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "A robust high performance CORBA ORB for C++ and Python";
    longDescription = ''
      omniORB is a robust high performance CORBA ORB for C++ and Python.
      It is freely available under the terms of the GNU Lesser General Public License
      (for the libraries),and GNU General Public License (for the tools).
      omniORB is largely CORBA 2.6 compliant.
    '';
    homepage    = "http://omniorb.sourceforge.net/";
    license     = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.unix;
  };
}
