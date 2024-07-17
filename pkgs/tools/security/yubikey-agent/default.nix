{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  libnotify,
  pcsclite,
  pkg-config,
  darwin,
}:

buildGoModule rec {
  pname = "yubikey-agent";

  version = "0.1.6";
  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "yubikey-agent";
    rev = "v${version}";
    sha256 = "sha256-Knk1ipBOzjmjrS2OFUMuxi1TkyDcSYlVKezDWT//ERY=";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optional stdenv.isDarwin (darwin.apple_sdk.frameworks.PCSC);

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace main.go --replace 'notify-send' ${libnotify}/bin/notify-send
  '';

  vendorHash = "sha256-+IRPs3wm3EvIgfQRpzcVpo2JBaFQlyY/RI1G7XfVS84=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p $out/lib/systemd/user
    substitute contrib/systemd/user/yubikey-agent.service $out/lib/systemd/user/yubikey-agent.service \
      --replace 'ExecStart=yubikey-agent' "ExecStart=$out/bin/yubikey-agent"
  '';

  meta = with lib; {
    description = "Seamless ssh-agent for YubiKeys";
    mainProgram = "yubikey-agent";
    license = licenses.bsd3;
    homepage = "https://filippo.io/yubikey-agent";
    maintainers = with lib.maintainers; [
      philandstuff
      rawkode
    ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
