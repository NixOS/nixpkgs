{
  stdenv, fetchurl,
  enablePython ? false, python ? null,
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.8.1";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "0v1vng43fjsh158zb5k5d81ngn4p4jmj1247m27pk0bfzy9dxv0v";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  buildInputs = stdenv.lib.optional enablePython python;

  configureFlags = [
    # z/OS plugin is not useful on Linux,
    # and pulls in an extra openldap dependency otherwise
    "--disable-zos-remote"
    (if enablePython then "--with-python" else "--without-python")
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Audit Library";
    homepage = http://people.redhat.com/sgrubb/audit/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
