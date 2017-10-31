{stdenv, fetchurl, libX11, glib, pkgconfig, libXmu }:

stdenv.mkDerivation rec {
  
  name = "wmctrl-1.07";
 
  src = fetchurl {
    url = "http://tomas.styblo.name/wmctrl/dist/${name}.tar.gz";
    sha256 = "1afclc57b9017a73mfs9w7lbdvdipmf9q0xdk116f61gnvyix2np";
  };
 
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXmu glib ];

  patches = [ ./64-bit-data.patch ];

  meta = {
    homepage = http://tomas.styblo.name/wmctrl/;
    description = "Command line tool to interact with an EWMH/NetWM compatible X Window Manager";
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
}
