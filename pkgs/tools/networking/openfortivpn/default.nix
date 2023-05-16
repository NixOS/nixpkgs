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
<<<<<<< HEAD
  version = "1.20.5";
=======
  version = "1.20.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-jbgxhCQWDw1ZUOAeLhOG+b6JYgvpr5TnNDIO/4k+e7k=";
=======
    hash = "sha256-3HKVHH9S409t07TgiZtw58AhQH6W+Ch8chsSmof1Jkk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
