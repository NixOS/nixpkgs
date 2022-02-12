{ lib, stdenv, fetchurl, python2 }:
stdenv.mkDerivation rec {

  pname = "omniorb";

  version = "4.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/omniorb/omniORB/omniORB-${version}/omniORB-${version}.tar.bz2";
    sha256 = "sha256-l2BFojQfTpqFBosh9L2SiZMpKTPu7O/qNy2wngIZ6t0=";
  };

  buildInputs = [ python2 ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "A robust high performance CORBA ORB for C++ and Python. It is freely available under the terms of the GNU Lesser General Public License (for the libraries), and GNU General Public License (for the tools). omniORB is largely CORBA 2.6 compliant";
    homepage    = "http://omniorb.sourceforge.net/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.unix;
  };
}
