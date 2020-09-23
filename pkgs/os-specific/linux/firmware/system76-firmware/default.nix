{ rustPlatform, lib, fetchFromGitHub, lzma, pkgconfig, openssl, dbus, efibootmgr, makeWrapper }:
rustPlatform.buildRustPackage rec {
  pname = "system76-firmware";
  # Check Makefile when updating, make sure postInstall matches make install
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = version;
    sha256 = "0cnrskfk3sam90lfpgsraqs4bx9yz8rxhwfs8rxdri04lakxgghg";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ lzma openssl dbus ];

  cargoBuildFlags = [ "--workspace" ];

  cargoSha256 = "06jrmxy68glcmbn9px29wc0s8pqdn26iy4jn3c246dapv1zvbb4s";

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
