{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config
, openssl, ppp
, systemd ? null }:

let
  withSystemd = stdenv.isLinux && !(systemd == null);

in
stdenv.mkDerivation rec {
  pname = "openfortivpn";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wijP9VGKXlxCAU3xN6+cv9+NGwBS55ql8WsZZ592b/k=";
  };

  # we cannot write the config file to /etc and as we don't need the file, so drop it
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace '$(DESTDIR)$(confdir)' /tmp
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];

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

  meta = with lib; {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = "https://github.com/adrienverge/openfortivpn";
    license = licenses.gpl3;
    maintainers = with maintainers; [ madjar ];
    platforms = with platforms; linux ++ darwin;
  };
}
