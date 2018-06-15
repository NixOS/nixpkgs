{ stdenv, fetchurl, python2 }:
stdenv.mkDerivation rec {

  name = "omniorb-${version}";

  version = "4.2.2";

  src = fetchurl rec {
    url = "mirror://sourceforge/project/omniorb/omniORB/omniORB-${version}/omniORB-${version}.tar.bz2";
    sha256 = "1klf6ivhsisdnqxcbf161jxva0xzmfgmwypnxfzf4jq16770knfx";
  };

  buildInputs = [ python2 ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "omniORB is a robust high performance CORBA ORB for C++ and Python. It is freely available under the terms of the GNU Lesser General Public License (for the libraries), and GNU General Public License (for the tools). omniORB is largely CORBA 2.6 compliant";
    homepage    = "http://omniorb.sourceforge.net/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.unix;
  };
}
