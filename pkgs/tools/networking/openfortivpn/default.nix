{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig
, openssl, ppp
, systemd ? null }:

let
  withSystemd = stdenv.isLinux && !(systemd == null);

in
stdenv.mkDerivation rec {
  pname = "openfortivpn";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qsfgpxg553s8rc9cyrc4k96z0pislxsdxb9wyhp8fdprkak2mw2";
  };

  # we cannot write the config file to /etc and as we don't need the file, so drop it
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace '$(DESTDIR)$(confdir)' /tmp
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [
    openssl ppp
  ]
  ++ lib.optional withSystemd systemd;

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-pppd=${ppp}/bin/pppd"
  ]
  ++ lib.optional withSystemd "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = "https://github.com/adrienverge/openfortivpn";
    license = licenses.gpl3;
    maintainers = with maintainers; [ madjar ];
    platforms = with platforms; linux ++ darwin;
  };
}
