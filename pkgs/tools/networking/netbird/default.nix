{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, xorg
, gtk3
, libayatana-appindicator-gtk3
}:
buildGoModule rec {
  pname = "netbird";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    rev = "v${version}";
    sha256 = "sha256-O/RfaDHiyzY3h4ubIFRgb6Tgge+bnZSfUb3X0wKGAnA";
  };

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libXinerama
    gtk3
    libayatana-appindicator-gtk3
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  vendorSha256 = "sha256-KtRQwrCBsOX7Jk9mKdDNOD7zfssADfBXCO1RPZbp5Aw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/netbirdio/netbird/client/system.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/client $out/bin/netbird
    mv $out/bin/management $out/bin/netbird-mgmt
    mv $out/bin/migration $out/bin/netbird-migration
    mv $out/bin/signal $out/bin/netbird-signal
    mv $out/bin/ui $out/bin/netbird-ui
  '';

  meta = with lib; {
    description = "Connect your devices into a single secure private WireGuard®-based mesh network";
    homepage = "https://netbird.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
