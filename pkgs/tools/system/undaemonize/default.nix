{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "undaemonize";
  src = fetchFromGitHub {
    repo = "undaemonize";
    owner = "nickstenning";
    rev = "master";
    sha256 = "1fkrgj3xfhj820qagh5p0rabl8z2hpad6yp984v92h9pgbfwxs33";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp undaemonize $out/bin/
  '';
  meta = {
    description = "Tiny helper utility to force programs which insist on daemonizing themselves to run in the foreground";
    homepage = "https://github.com/nickstenning/undaemonize";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.canndrew ];
    platforms = stdenv.lib.platforms.linux;
  };
}

