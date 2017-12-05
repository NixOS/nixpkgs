{stdenv, fetchurl, xlibsWrapper, imake}:

stdenv.mkDerivation {
  name = "x11-ssh-askpass-1.2.4.1";

  src = fetchurl {
    url = http://www.jmknoble.net/software/x11-ssh-askpass/x11-ssh-askpass-1.2.4.1.tar.gz;
    sha1 = "78c992951685d4dbffb77536f37b83ae2a6eafc7";
  };

  preConfigure = "
    configureFlags=\"--with-app-defaults-dir=$out/etc/X11/app-defaults\"
  ";

  buildPhase = "xmkmf; make includes; make";

  buildInputs = [xlibsWrapper imake];

  meta = {
    homepage = http://www.jmknoble.net/software/x11-ssh-askpass/;
    description = "Lightweight passphrase dialog for OpenSSH or other open variants of SSH";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [];
  };
}
