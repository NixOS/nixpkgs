{ stdenv, fetchurl, xlibsWrapper, imake, gccmakedep }:

stdenv.mkDerivation {
  name = "x11-ssh-askpass-1.2.4.1";

  outputs = [ "out" "man" ];

  src = fetchurl {
    url = http://pkgs.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz;
    sha256 = "620de3c32ae72185a2c9aeaec03af24242b9621964e38eb625afb6cdb30b8c88";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ xlibsWrapper ];

  configureFlags = [
    "--with-app-defaults-dir=$out/etc/X11/app-defaults"
  ];

  dontUseImakeConfigure = true;
  postConfigure = ''
    xmkmf -a
  '';

  installTargets = [ "install" "install.man" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sigmavirus24/x11-ssh-askpass;
    description = "Lightweight passphrase dialog for OpenSSH or other open variants of SSH";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
