{ stdenv, fetchurl, openldap
, enablePython ? false, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.4";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "16z9iyi7yzkbyczrkmk9g0i3mlivr7l4p0hgyrz4f04xmzkkjpbf";
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
