{ stdenv, fetchurl, libpcap, sendmailPath ? "/var/setuid-wrappers/sendmail" }:

stdenv.mkDerivation rec {
  name = "arpwatch-${version}";
  version = "2.1a15";

  src = fetchurl {
    url = "ftp://ftp.ee.lbl.gov/${name}.tar.gz";
    sha256 = "162qzw2lppwygs8kqbwrz1kbxndlyj1svpcjz9hnma88w8vrgpy1";
  };

  buildInputs = [ libpcap ];

  postPatch = ''
    substituteInPlace configure \
      --replace '/usr/lib/sendmail' '${sendmailPath}'
    substituteInPlace Makefile.in \
      --replace ' -o bin -g bin ' ' ' \
      --replace '@sbindir@' $out/bin
  '';

  preInstall = ''
    mkdir -p $out/{bin,man/man8}
  '';

  postInstall = ''
    make install-man
  '';

  meta = with stdenv.lib; {
    description = "Ethernet monitor program; for keeping track of ethernet/ip address pairings";
    homepage = "http://ee.lbl.gov/";
    maintainers = [ maintainers.globin ];
    platforms = platforms.linux;
    license = licenses.bsd3-lbnl;
  };
}
