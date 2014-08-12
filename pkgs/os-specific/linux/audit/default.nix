{ stdenv, fetchurl, openldap
, enablePython ? false, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.3.2";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "0a8x10wz0xfj0iq1wgjl6hdhxvq58cb3906vc687i21876sy0wl8";
  };

  buildInputs = [ openldap ]
            ++ stdenv.lib.optional enablePython python;

  configureFlags = ''
    ${if enablePython then "--with-python" else "--without-python"}
  '';

  meta = {
    description = "Audit Library";
    homepage = "http://people.redhat.com/sgrubb/audit/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
