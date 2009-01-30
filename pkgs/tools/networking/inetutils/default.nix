{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "inetutils-1.6";

  src = fetchurl {
    url = "mirror://gnu/inetutils/${name}.tar.gz";
    sha256 = "1pjv2h8mwbyjrw75xn1k1z7ps4z4y0x6ljizwrzkh83n7d3xjaq5";
  };

  postInstall = ''
    # XXX: These programs are normally installed setuid but since it
    # fails, they end up being non-executable, hence this hack.
    chmod +x $out/bin/{ping,ping6,rcp,rlogin,rsh}
  '';

  meta = {
    description = "GNU Inetutils, a collection of common network programs";

    longDescription = ''
      GNU Inetutils is a collection of common network programs,
      including telnet, FTP, RSH, rlogin and TFTP clients and servers,
      among others.
    '';

    homepage = http://www.gnu.org/software/inetutils/;
    license = "GPLv3+";
  };
}
