{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
, ppp
, systemd
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, withPpp ? stdenv.isLinux
}:

stdenv.mkDerivation rec {
  pname = "openfortivpn";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7Yf22EpOTEGGqPoNGnHFyn5A4n7aYFXoSE1G6zyzT3M=";
  };

  # we cannot write the config file to /etc and as we don't need the file, so drop it
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace '$(DESTDIR)$(confdir)' /tmp
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional withSystemd systemd
  ++ lib.optional withPpp ppp;

  configureFlags = [
    "--sysconfdir=/etc"
  ]
  ++ lib.optional withSystemd "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ++ lib.optional withPpp "--with-pppd=${ppp}/bin/pppd";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = "https://github.com/adrienverge/openfortivpn";
    license = licenses.gpl3;
    maintainers = with maintainers; [ madjar ];
    platforms = with platforms; linux ++ darwin;
  };
}
