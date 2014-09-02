{ stdenv, fetchgit, openssl
, privsepPath ? "/var/empty"
, privsepUser ? "ntp"
}:

stdenv.mkDerivation rec {
  name = "openntpd-${version}";
  version = "20080406p-10";

  src = fetchgit {
    url = "git://git.debian.org/collab-maint/openntpd.git";
    rev = "refs/tags/debian/${version}";
    sha256 = "0gd6j4sw4x4adlz0jzbp6lblx5vlnk6l1034hzbj2xd95k8hjhh8";
  };

  postPatch = ''
    sed -i -e '/^install:/,/^$/{/@if.*PRIVSEP_PATH/,/^$/d}' Makefile.in
  '';

  configureFlags = [
    "--with-privsep-path=${privsepPath}"
    "--with-privsep-user=${privsepUser}"
  ];

  buildInputs = [ openssl ];

  meta = {
    homepage = "http://www.openntpd.org/";
    license = stdenv.lib.licenses.bsd3;
    description = "OpenBSD NTP daemon (Debian port)";
  };
}
