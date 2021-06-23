{ pkg-config, libusb1, dbus, lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "system76-power";
  version = "1.1.16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-power";
    rev = version;
    sha256 = "sha256-OtrhvUkNNgg6KlrqjwiBKL4zuQZBWevb0xgtSlEW2rQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus libusb1 ];

  cargoSha256 = "sha256-ImACDbnUbwc0ZXgF3xxzes8+vUjt76B1xxgqzhgAYX4=";

  postInstall = ''
    install -D -m 0644 data/system76-power.conf $out/etc/dbus-1/system.d/system76-power.conf
  '';

  meta = with lib; {
    description = "System76 Power Management";
    homepage = "https://github.com/pop-os/system76-power";
    license = licenses.gpl3Plus;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ maintainers.jwoudenberg ];
  };
}
