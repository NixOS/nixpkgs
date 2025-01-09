{
  stdenv,
  lib,
  nixosTests,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  gtk3,
  libayatana-appindicator,
  libX11,
  libXcursor,
  libXxf86vm,
  Cocoa,
  IOKit,
  Kernel,
  UserNotifications,
  WebKit,
  fetchpatch2,
  ui ? false,
  netbird-ui,
}:
let
  modules =
    if ui then
      {
        "client/ui" = "netbird-ui";
      }
    else
      {
        client = "netbird";
        management = "netbird-mgmt";
        signal = "netbird-signal";
      };
in
buildGoModule rec {
  pname = "netbird";
  version = "0.35.1";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    rev = "v${version}";
    hash = "sha256-PgJm0+HqJMdDjbX+9a86BmicArJCiegf4n7A1sHNQ0Y=";
  };

  vendorHash = "sha256-CgfZZOiFDLf6vCbzovpwzt7FlO9BnzNSdR8e5U+xCDQ=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional ui pkg-config;

  buildInputs =
    lib.optionals (stdenv.hostPlatform.isLinux && ui) [
      gtk3
      libayatana-appindicator
      libX11
      libXcursor
      libXxf86vm
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && ui) [
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
    "-X github.com/netbirdio/netbird/version.version=${version}"
    "-X main.builtBy=nix"
  ];

  # needs network access
  doCheck = false;

  patches = [
    (fetchpatch2 {
      # add support for NB_STATE_DIR see https://github.com/netbirdio/netbird/pull/3084
      url = "https://github.com/netbirdio/netbird/commit/eddff4258fc9d6c8be6afafb1e49c67a7fed7cfe.patch?full_index=1";
      sha256 = "sha256-8gCLl2qO4NcG7U4TKZiW/omWFoKrUURWtHxYrPf8SP8=";
    })
  ];

  postPatch = ''
    # make it compatible with systemd's RuntimeDirectory
    substituteInPlace client/cmd/root.go \
      --replace-fail 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
    substituteInPlace client/ui/client_ui.go \
      --replace-fail 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
  '';

  postInstall =
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        module: binary:
        ''
          mv $out/bin/${lib.last (lib.splitString "/" module)} $out/bin/${binary}
        ''
        + lib.optionalString (!ui) ''
          installShellCompletion --cmd ${binary} \
            --bash <($out/bin/${binary} completion bash) \
            --fish <($out/bin/${binary} completion fish) \
            --zsh <($out/bin/${binary} completion zsh)
        ''
      ) modules
    )
    + lib.optionalString (stdenv.hostPlatform.isLinux && ui) ''
      mkdir -p $out/share/pixmaps
      cp $src/client/ui/netbird-systemtray-connected.png $out/share/pixmaps/netbird.png

      mkdir -p $out/share/applications
      cp $src/client/ui/netbird.desktop $out/share/applications/netbird.desktop

      substituteInPlace $out/share/applications/netbird.desktop \
        --replace-fail "Exec=/usr/bin/netbird-ui" "Exec=$out/bin/netbird-ui"
    '';

  passthru = {
    tests.netbird = nixosTests.netbird;
    tests.netbird-ui = netbird-ui;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://netbird.io";
    changelog = "https://github.com/netbirdio/netbird/releases/tag/v${version}";
    description = "Connect your devices into a single secure private WireGuard®-based mesh network with SSO/MFA and simple access controls";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      vrifox
      saturn745
    ];
    mainProgram = if ui then "netbird-ui" else "netbird";
  };
}
