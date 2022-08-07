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
  vendorSha256 = "sha256-H05EJwYDdg4lq6+psXiwujQd5g294epdRPjqviHhLWs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libnotify ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} *.md

    install -Dm444 -t $out/lib/systemd/user *.{service,socket}

    substituteInPlace $out/lib/systemd/user/*.service \
      --replace /usr/bin/yubikey-touch-detector "$out/bin/yubikey-touch-detector --libnotify"
  '';

  meta = with lib; {
    description = "A tool to detect when your YubiKey is waiting for a touch (to send notification or display a visual indicator on the screen).";
    homepage = "https://github.com/maximbaz/yubikey-touch-detector";
    maintainers = with maintainers; [ sumnerevans ];
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
