{ pkg-config, libusb1, dbus, lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "system76-power";
  version = "1.1.18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-power";
    rev = version;
    sha256 = "1zm06ywc3siwh2fpb8p7lp3xqjy4c08j8c8lipd6dyy3bakjh4r1";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus libusb1 ];

  cargoSha256 = "0hda8cxa1pjz90bg215qmx5x2scz9mawq7irxbsw6zmcm7wahlii";

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
