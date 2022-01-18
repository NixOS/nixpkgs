{ lib, stdenv
, python3Packages
, fetchFromGitHub
, systemd
, xrandr
, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "autorandr";
  version = "1.12.1";

  buildInputs = [ python3Packages.python ];

  nativeBuildInputs = [ installShellFiles ];

  # no wrapper, as autorandr --batch does os.environ.clear()
  buildPhase = ''
    substituteInPlace autorandr.py \
      --replace 'os.popen("xrandr' 'os.popen("${xrandr}/bin/xrandr' \
      --replace '["xrandr"]' '["${xrandr}/bin/xrandr"]'
  '';

  outputs = [ "out" "man" ];

  installPhase = ''
    runHook preInstall
    make install TARGETS='autorandr' PREFIX=$out

    # zsh completions exist but currently have no make target, use
    # installShellCompletions for both
    # see https://github.com/phillipberndt/autorandr/issues/197
    installShellCompletion --cmd autorandr \
        --bash contrib/bash_completion/autorandr \
        --zsh contrib/zsh_completion/_autorandr

    make install TARGETS='autostart_config' PREFIX=$out DESTDIR=$out

    make install TARGETS='manpage' PREFIX=$man

    ${if systemd != null then ''
      make install TARGETS='systemd udev' PREFIX=$out DESTDIR=$out \
        SYSTEMD_UNIT_DIR=/lib/systemd/system \
        UDEV_RULES_DIR=/etc/udev/rules.d
      substituteInPlace $out/etc/udev/rules.d/40-monitor-hotplug.rules \
        --replace /bin/systemctl "/run/current-system/systemd/bin/systemctl"
    '' else ''
      make install TARGETS='pmutils' DESTDIR=$out \
        PM_SLEEPHOOKS_DIR=/lib/pm-utils/sleep.d
      make install TARGETS='udev' PREFIX=$out DESTDIR=$out \
        UDEV_RULES_DIR=/etc/udev/rules.d
    ''}

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "autorandr";
    rev = version;
    sha256 = "sha256-7SNnbgV6PeseBD6wdilEIOfOL2KVDpnlkSn9SBgRhhM=";
  };

  meta = with lib; {
    homepage = "https://github.com/phillipberndt/autorandr/";
    description = "Automatically select a display configuration based on connected devices";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ coroa globin ];
    platforms = platforms.unix;
  };
}
