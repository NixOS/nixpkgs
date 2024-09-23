{ lib, stdenv, fetchurl, ncurses, libpcap, automake, nixosTests }:

stdenv.mkDerivation rec {
  pname = "iftop";
  version = "1.0pre4";

  src = fetchurl {
    url = "http://ex-parrot.com/pdw/iftop/download/iftop-${version}.tar.gz";
    sha256 = "15sgkdyijb7vbxpxjavh5qm5nvyii3fqcg9mzvw7fx8s6zmfwczp";
  };

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".
  LDFLAGS = lib.optionalString stdenv.isLinux "-lgcc_s";

  preConfigure = ''
    cp ${automake}/share/automake*/config.{sub,guess} config
  '';

  buildInputs = [ncurses libpcap];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: tui.o:/build/iftop-1.0pre4/ui_common.h:41: multiple definition of `service_hash';
  #     iftop.o:/build/iftop-1.0pre4/ui_common.h:41: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  passthru.tests = { inherit (nixosTests) iftop; };

  meta = with lib; {
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
    mainProgram = "iftop";
  };
}
