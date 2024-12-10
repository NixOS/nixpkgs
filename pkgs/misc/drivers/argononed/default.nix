{
  lib,
  stdenv,
  fetchFromGitLab,
  dtc,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "argononed";
  version = "unstable-2022-03-26";

  src = fetchFromGitLab {
    owner = "DarkElvenAngel";
    repo = pname;
    rev = "97c4fa07fc2c09ffc3bd86e0f6319d50fa639578";
    sha256 = "sha256-5/xUYbprRiwD+FN8V2cUpHxnTbBkEsFG2wfsEXrCrgQ=";
  };

  patches = [ ./fix-hardcoded-reboot-poweroff-paths.patch ];

  postPatch = ''
    patchShebangs configure
  '';

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ dtc ];

  installPhase = ''
    runHook preInstall

    install -Dm755 build/argononed $out/bin/argononed
    install -Dm755 build/argonone-cli $out/bin/argonone-cli
    install -Dm755 build/argonone-shutdown $out/lib/systemd/system-shutdown/argonone-shutdown
    install -Dm644 build/argonone.dtbo $out/boot/overlays/argonone.dtbo

    install -Dm644 OS/_common/argononed.service $out/lib/systemd/system/argononed.service
    install -Dm644 OS/_common/argononed.logrotate $out/etc/logrotate.d/argononed
    install -Dm644 LICENSE $out/share/argononed/LICENSE

    installShellCompletion --bash --name argonone-cli OS/_common/argonone-cli-complete.bash

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/DarkElvenAngel/argononed";
    description = "A replacement daemon for the Argon One Raspberry Pi case";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.misterio77 ];
  };
}
