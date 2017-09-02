{ stdenv, fetchurl, openldap
, enablePython ? false, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.7.7";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "1vvqw5xgirap0jdmajw7l3pq563aycvy3hlqvj3k2cac8i4jbqlq";
  };

  outputs = [ "bin" "dev" "out" "man" "plugins" ];

  buildInputs = [ openldap ]
            ++ stdenv.lib.optional enablePython python;

  configureFlags = ''
    ${if enablePython then "--with-python" else "--without-python"}
  '';

  enableParallelBuilding = true;

  postInstall =
    ''
      # Move the z/OS plugin to a separate output to prevent an
      # openldap runtime dependency in audit.bin.
      mkdir -p $plugins/bin
      mv $bin/sbin/audispd-zos-remote $plugins/bin/
    '';

  meta = {
    description = "Audit Library";
    homepage = http://people.redhat.com/sgrubb/audit/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
