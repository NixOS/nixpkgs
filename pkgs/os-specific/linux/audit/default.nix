{ stdenv, fetchurl, openldap
, enablePython ? false, python ? null
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.6.6";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "0jwrww1vn7yqxmb84n6y4p58z34gga0ic4rs2msvpzc2x1hxrn31";
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
    homepage = "http://people.redhat.com/sgrubb/audit/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
