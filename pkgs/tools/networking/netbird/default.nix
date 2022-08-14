{ stdenv, lib, nixosTests, buildGoModule, fetchFromGitHub, installShellFiles
, pkg-config
, libayatana-appindicator, libX11, libXcursor, libXxf86vm
, Cocoa, IOKit, Kernel, UserNotifications, WebKit
, ui ? false }:
let
  modules = if ui then {
    "client/ui" = "netbird-ui";
  } else {
    client = "netbird";
    management = "netbird-mgmt";
    signal = "netbird-signal";
  };
in
buildGoModule rec {
  pname = "netbird";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bQrfYbzYd6T9PD2lLuldp1pGoZKpU71bO1D1SXcoZ7M=";
  };

  vendorSha256 = "sha256-KtRQwrCBsOX7Jk9mKdDNOD7zfssADfBXCO1RPZbp5Aw=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional ui pkg-config;

  buildInputs = lib.optionals (stdenv.isLinux && ui) [
    libayatana-appindicator
    libX11
    libXcursor
    libXxf86vm
  ] ++ lib.optionals (stdenv.isDarwin && ui) [
    Cocoa
    IOKit
    Kernel
    UserNotifications
    WebKit
  ];

  subPackages = lib.attrNames modules;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/netbirdio/netbird/client/system.version=${version}"
    "-X main.builtBy=nix"
  ];

  # needs network access
  doCheck = false;

  postPatch = ''
    # make it compatible with systemd's RuntimeDirectory
    substituteInPlace client/cmd/root.go \
      --replace 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
    substituteInPlace client/ui/client_ui.go \
      --replace 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
  '';

  postInstall = lib.concatStringsSep "\n" (lib.mapAttrsToList
    (module: binary: ''
      mv $out/bin/${lib.last (lib.splitString "/" module)} $out/bin/${binary}
    '' + lib.optionalString (!ui) ''
      installShellCompletion --cmd ${binary} \
        --bash <($out/bin/${binary} completion bash) \
        --fish <($out/bin/${binary} completion fish) \
        --zsh <($out/bin/${binary} completion zsh)
    '')
    modules) + lib.optionalString (stdenv.isLinux && ui) ''
      mkdir -p $out/share/pixmaps
      cp $src/client/ui/disconnected.png $out/share/pixmaps/netbird.png

      mkdir -p $out/share/applications
      cp $src/client/ui/netbird.desktop $out/share/applications/netbird.desktop

      substituteInPlace $out/share/applications/netbird.desktop \
        --replace "Exec=/usr/bin/netbird-ui" "Exec=$out/bin/netbird-ui"
    '';

  passthru.tests.netbird = nixosTests.netbird;

  meta = with lib; {
    homepage = "https://netbird.io";
    description = "Connect your devices into a single secure private WireGuard®-based mesh network with SSO/MFA and simple access controls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ misuzu ];
  };
}
