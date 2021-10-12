{ lib, libnotify, buildGoModule, fetchFromGitHub, pkg-config }:

buildGoModule rec {
  pname = "yubikey-touch-detector";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "yubikey-touch-detector";
    rev = version;
    sha256 = "sha256-I9dRCQhbXd8K1zp291z9XVwHI9DcxgvrzYaHICZH5v0=";
  };
  vendorSha256 = "sha256-UeDLGwYrXwLOtQt/8fEmficc/1j0x+zr/JLa6lLF5cs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libnotify ];

  meta = with lib; {
    description = "A tool to detect when your YubiKey is waiting for a touch (to send notification or display a visual indicator on the screen).";
    homepage = "https://github.com/maximbaz/yubikey-touch-detector";
    maintainers = with maintainers; [ sumnerevans ];
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
