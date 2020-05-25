{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "undaemonize-2017-07-11";
  src = fetchFromGitHub {
    repo = "undaemonize";
    owner = "nickstenning";
    rev = "a181cfd900851543ee1f85fe8f76bc8916b446d4";
    sha256 = "1fkrgj3xfhj820qagh5p0rabl8z2hpad6yp984v92h9pgbfwxs33";
  };
  installPhase = ''
    install -D undaemonize $out/bin/undaemonize
  '';
  meta = {
    description = "Tiny helper utility to force programs which insist on daemonizing themselves to run in the foreground";
    homepage = "https://github.com/nickstenning/undaemonize";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.canndrew ];
    platforms = stdenv.lib.platforms.linux;
  };
}

