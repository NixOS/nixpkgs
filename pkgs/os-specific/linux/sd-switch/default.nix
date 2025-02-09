{ lib, fetchFromSourcehut, rustPlatform, pkg-config, dbus }:

let version = "0.3.0";
in rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-mWrLbCUnoJ3hVtpSU/7dw91U5TLyw5kNchX5nmP9asA=";
  };

  cargoHash = "sha256-VK+kPX1pGhowbWKkUs1PL0DXIhDXJOFVoIHTtWQcWEs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "A systemd unit switcher for Home Manager";
    homepage = "https://gitlab.com/rycee/sd-switch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
