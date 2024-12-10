{
  pkg-config,
  libusb1,
  dbus,
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "system76-power";
  version = "1.1.23";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-power";
    rev = version;
    sha256 = "sha256-RuYDG4eZE599oa04xUR+W5B3/IPOpQUss1x7hzoydUQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dbus
    libusb1
  ];

  cargoSha256 = "sha256-Vps02ZRVmeOQ8jDFZJYAUb502MhqY+2YV2W1/9XGY+0=";

  postInstall = ''
    install -D -m 0644 data/com.system76.PowerDaemon.conf $out/etc/dbus-1/system.d/com.system76.PowerDaemon.conf
    install -D -m 0644 data/com.system76.PowerDaemon.policy $out/share/polkit-1/actions/com.system76.PowerDaemon.policy
    install -D -m 0644 data/com.system76.PowerDaemon.xml $out/share/dbus-1/interfaces/com.system76.PowerDaemon.xml
  '';

  meta = with lib; {
    description = "System76 Power Management";
    mainProgram = "system76-power";
    homepage = "https://github.com/pop-os/system76-power";
    license = licenses.gpl3Plus;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = [ maintainers.jwoudenberg ];
  };
}
