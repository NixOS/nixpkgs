{ stdenv, fetchurl, openldap
, enablePython ? false, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.4.4";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "08sfcx8ykcn5jsryil15q8yqm0a8czymyqbb2sqxfc1jbx37zx95";
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
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
