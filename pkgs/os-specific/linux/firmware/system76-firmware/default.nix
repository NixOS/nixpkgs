{ rustPlatform, lib, fetchFromGitHub, lzma, pkgconfig, openssl, dbus, efibootmgr, makeWrapper }:
rustPlatform.buildRustPackage rec {
  pname = "system76-firmware";
  # Check Makefile when updating, make sure postInstall matches make install
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = version;
    sha256 = "0yjv3a8r01ks91gc33rdwqmw52cqqwhq9f3rvw2xv3h8cqa5hfz0";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ lzma openssl dbus ];

  cargoBuildFlags = [ "--workspace" ];

  cargoSha256 = "1ivn3i6kpnswiipqw5s67p6gsz3y6an0ahf6vwz7dlw2xaha0xbx";

  # Purposefully don't install systemd unit file, that's for NixOS
  postInstall = ''
    install -D -m -0644 data/system76-firmware-daemon.conf $out/etc/dbus-1/system.d/system76-firmware-daemon.conf

    for bin in $out/bin/system76-firmware-*
    do
      wrapProgram $bin --prefix PATH : "${efibootmgr}/bin"
    done
  '';

  meta = {
    description = "Tools for managing firmware updates for system76 devices.";
    homepage = "https://github.com/pop-os/system76-firmware";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.shlevy ];
    platforms = lib.platforms.linux;
  };
}
