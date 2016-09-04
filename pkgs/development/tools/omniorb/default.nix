{ stdenv, fetchurl, python }:
stdenv.mkDerivation rec {

  name = "omniorb-${version}";

  version = "4.2.0";

  src = fetchurl rec {
    url = "mirror://sourceforge/project/omniorb/omniORB/omniORB-${version}/omniORB-${version}.tar.bz2";
    sha256 = "1g58xcw4641wyisp9wscrkzaqrz0vf123dgy52qq2a3wk7y77hkl";
  };

  buildInputs = [ python ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "omniORB is a robust high performance CORBA ORB for C++ and Python. It is freely available under the terms of the GNU Lesser General Public License (for the libraries), and GNU General Public License (for the tools). omniORB is largely CORBA 2.6 compliant";
    homepage    = "http://omniorb.sourceforge.net/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.unix;
  };
}
