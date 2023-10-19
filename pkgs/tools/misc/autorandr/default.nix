{ lib
, python3
, fetchFromGitHub
, systemd
, xrandr
, installShellFiles
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autorandr";
  version = "1.14";
  format = "other";

  src = fetchFromGitHub {
    owner = "phillipberndt";
    repo = "autorandr";
    rev = "refs/tags/${version}";
    hash = "sha256-Ru3nQF0DB98rKSew6QtxAZQEB/9nVlIelNX3M7bNYHk=";
  };

  nativeBuildInputs = [ installShellFiles desktop-file-utils ];
  propagatedBuildInputs = with python3.pkgs; [ packaging ];

  buildPhase = ''
    substituteInPlace autorandr.py \
      --replace 'os.popen("xrandr' 'os.popen("${xrandr}/bin/xrandr' \
      --replace '["xrandr"]' '["${xrandr}/bin/xrandr"]'
  '';

  patches = [ ./0001-don-t-use-sys.executable.patch ];

  outputs = [ "out" "man" ];

  installPhase = ''
    runHook preInstall
    make install TARGETS='autorandr' PREFIX=$out

    # zsh completions exist but currently have no make target, use
    # installShellCompletions for both
    # see https://github.com/phillipberndt/autorandr/issues/197
    installShellCompletion --cmd autorandr \
        --bash contrib/bash_completion/autorandr \
        --zsh contrib/zsh_completion/_autorandr \
        --fish contrib/fish_copletion/autorandr.fish
    # In the line above there's a typo that needs to be fixed in the next
    # release

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

  meta = with lib; {
    homepage = "https://github.com/phillipberndt/autorandr/";
    description = "Automatically select a display configuration based on connected devices";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ coroa globin ];
    platforms = platforms.unix;
    mainProgram = "autorandr";
  };
}
