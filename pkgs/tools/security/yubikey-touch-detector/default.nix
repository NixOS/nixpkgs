{ lib, libnotify, buildGoModule, fetchFromGitHub, pkg-config }:

buildGoModule rec {
  pname = "yubikey-touch-detector";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "yubikey-touch-detector";
    rev = version;
    sha256 = "sha256-f6j+YNYASH0Adg3236QijApALd/yXJjNMYEdP0Pifw0=";
  };
  vendorSha256 = "sha256-bmFbxMU3PEWpYI0eQw/1RRDP+JGfUY8kOCeTWbdVt9k=";

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
