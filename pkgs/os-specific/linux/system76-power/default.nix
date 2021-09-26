{ pkg-config, libusb1, dbus, lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "system76-power";
  version = "1.1.17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-power";
    rev = version;
    sha256 = "sha256-9ndukZPNB0qtU0hA9eUYpiAC8Tw1eF16W+sVU7XKvsg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus libusb1 ];

  cargoSha256 = "sha256-6mtBY77d2WAwTpj+g0KVpW/n39uanAL2GNHWC8Qbtqk=";

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
