{ stdenv, fetchhg, autoconf, automake, dovecot, openssl }:

stdenv.mkDerivation {
  name = "dovecot-antispam-20130429";

  src = fetchhg {
    url = "http://hg.dovecot.org/dovecot-antispam-plugin/";
    rev = "5ebc6aae4d7c";
    sha256 = "181i79c9sf3a80mgmycfq1f77z7fpn3j2s0qiddrj16h3yklf4gv";
  };

  buildInputs = [ dovecot openssl ];
  nativeBuildInputs = [ autoconf automake ];

  preConfigure = ''
    ./autogen.sh
    # Ugly hack; any ideas?
    sed "s,^dovecot_moduledir=.*,dovecot_moduledir=$out/lib/dovecot," ${dovecot}/lib/dovecot/dovecot-config > dovecot-config
  '';

  configureFlags = [
    "--with-dovecot=."
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://wiki2.dovecot.org/Plugins/Antispam;
    description = "An antispam plugin for the Dovecot IMAP server";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
