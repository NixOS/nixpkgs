{ stdenv, fetchurl, ncurses, libpcap, automake, nixosTests }:

stdenv.mkDerivation {
  name = "iftop-1.0pre4";

  src = fetchurl {
    url = "http://ex-parrot.com/pdw/iftop/download/iftop-1.0pre4.tar.gz";
    sha256 = "15sgkdyijb7vbxpxjavh5qm5nvyii3fqcg9mzvw7fx8s6zmfwczp";
  };

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".
  LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  preConfigure = ''
    cp ${automake}/share/automake*/config.{sub,guess} config
  '';

  buildInputs = [ncurses libpcap];

  passthru.tests = { inherit (nixosTests) iftop; };

  meta = with stdenv.lib; {
    description = "Display bandwidth usage on a network interface";
    longDescription = ''
      iftop does for network usage what top(1) does for CPU usage. It listens
      to network traffic on a named interface and displays a table of current
      bandwidth usage by pairs of hosts.
    '';
    license = licenses.gpl2Plus;
    homepage = "http://ex-parrot.com/pdw/iftop/";
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
