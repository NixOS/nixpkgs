{
  stdenv, fetchurl,
  enablePython ? false, python ? null,
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.8.2";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "1fmw8whraz1q3y3z5mgdpgsa3wz6r3zq0kgsgbc9xvmgfwmrpdb7";
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
