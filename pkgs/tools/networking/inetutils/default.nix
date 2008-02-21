{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "inetutils-1.5";
  src = fetchurl {
    url = "mirror://gnu/inetutils/${name}.tar.gz";
    sha256 = "048my5fgxnjwr1jcka8yq36c7i019p60r0mg4f6zz96pmys76p1l";
  };

  # Make sure `configure' honors `$TMPDIR' for chroot builds.
  patchPhase = ''
    cat configure | sed -'es|/tmp/,iu|$TMPDIR/,iu|g' > ,,tmp && \
    mv ,,tmp configure && chmod +x configure
  '';

  postInstall = ''
    # XXX: These programs are normally installed setuid but since it
    # fails, they end up being non-executable, hence this hack.
    chmod +x $out/bin/{ping,ping6,rcp,rlogin,rsh}
  '';

  meta = {
    description = ''GNU Inetutils is a collection of common network
                    programs, including telnet, FTP, RSH, rlogin and
		    TFTP clients and servers, among others.'';
    homepage = http://www.gnu.org/software/inetutils/;
    license = "GPLv3+";
  };
}
