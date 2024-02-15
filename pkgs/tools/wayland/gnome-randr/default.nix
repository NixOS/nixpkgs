{ dbus
, fetchFromGitHub
, lib
, pkg-config
, rustPlatform
}:
let
  version = "0.1.1";
in
rustPlatform.buildRustPackage {
  pname = "gnome-randr";
  inherit version;

  src = fetchFromGitHub {
    owner = "maxwellainatchi";
    repo = "gnome-randr-rust";
    rev = "v" + version;
    sha256 = "sha256-mciHgBEOCFjRA4MSoEdP7bIag0KE+zRbk4wOkB2PAn0=";
  };

  cargoSha256 = "sha256-rk8/sg5rSNS741QOWoAGIloqph+ZdBjl/xUaFl0A3Bs=";

  buildInputs = [ dbus ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "An xrandr-like CLI for configuring displays on GNOME/Wayland, on distros that don't support `wlr-randr`";
    homepage = "https://github.com/maxwellainatchi/gnome-randr-rust";
    license = licenses.mit;
    maintainers = [ maintainers.roberth ];
    platforms = platforms.linux;
    mainProgram = "gnome-randr";
  };
}
