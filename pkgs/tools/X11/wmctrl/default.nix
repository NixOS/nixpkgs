{ stdenv
, fetchurl
, libX11
, glib
, pkgconfig
, libXmu
}:

stdenv.mkDerivation rec {

  pname = "wmctrl";
  version = "1.07";

  src = fetchurl {
    # NOTE: 2019-04-11: There is also a semi-official mirror: http://tripie.sweb.cz/utils/wmctrl/
    url = "https://sites.google.com/site/tstyblo/wmctrl/${pname}-${version}.tar.gz";
    sha256 = "1afclc57b9017a73mfs9w7lbdvdipmf9q0xdk116f61gnvyix2np";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXmu glib ];

  patches = [ ./64-bit-data.patch ];

  meta = {
    homepage = https://sites.google.com/site/tstyblo/wmctrl;
    description = "CLI tool to interact with EWMH/NetWM compatible X Window Managers";
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; all;
    maintainers = [ stdenv.lib.maintainers.Anton-Latukha ];
  };

}
