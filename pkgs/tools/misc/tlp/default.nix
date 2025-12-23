{
  stdenv,
  lib,
  checkbashisms,
  coreutils,
  ethtool,
  fetchFromGitHub,
  gawk,
  gnugrep,
  gnused,
  hdparm,
  iw,
  kmod,
  makeWrapper,
  pciutils,
  perl,
  perlcritic,
  shellcheck,
  smartmontools,
  systemd,
  udevCheckHook,
  util-linux,
  x86_energy_perf_policy,
  # RDW only works with NetworkManager, and thus is optional with default off
  enableRDW ? false,
  networkmanager,
  enablePD ? false,
  python3,
  glib,
}:
stdenv.mkDerivation rec {
  pname = "tlp";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "linrunner";
    repo = "TLP";
    rev = version;
    hash = "sha256-aM/4+cgtUe6qv3MNT4moXvNzqG5gKvwMbg14L8ifWlc=";
  };

  # XXX: See patch files for relevant explanations.
  patches = [
    ./patches/0001-makefile-correctly-sed-paths.patch
    ./patches/0002-reintroduce-tlp-sleep-service.patch
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail ' ?= /usr/' ' ?= /'
  '';

  buildInputs = [
    perl
  ]
  ++ lib.optional enablePD (
    python3.withPackages (
      ps: with ps; [
        dbus-python
        pygobject3
      ]
    )
  );

  nativeBuildInputs = [
    makeWrapper
    udevCheckHook
  ];

  # XXX: While [1] states that DESTDIR should not be used, and that the correct
  # variable to set is, in fact, PREFIX, tlp thinks otherwise. The Makefile for
  # tlp concerns itself only with DESTDIR [2] (possibly incorrectly) and so we set
  # that as opposed to PREFIX, despite what [1] says.
  #
  # [1]: https://github.com/NixOS/nixpkgs/issues/65718
  # [2]: https://github.com/linrunner/TLP/blob/ab788abf4936dfb44fbb408afc34af834230a64d/Makefile#L4-L46
  makeFlags = [
    "TLP_NO_INIT=1"
    "TLP_WITH_ELOGIND=0"
    "TLP_WITH_SYSTEMD=1"

    "DESTDIR=${placeholder "out"}"
  ];

  installTargets = [
    "install-tlp"
    "install-man"
  ]
  ++ lib.optionals enableRDW [
    "install-rdw"
    "install-man-rdw"
  ]
  ++ lib.optional enablePD "install-pd";

  doCheck = true;
  nativeCheckInputs = [
    checkbashisms
    perlcritic
    shellcheck
  ];
  checkTarget = [ "checkall" ];

  doInstallCheck = true;

  # TODO: Consider using resholve here
  postInstall =
    let
      paths = lib.makeBinPath (
        [
          coreutils
          ethtool
          gawk
          gnugrep
          gnused
          hdparm
          iw
          kmod
          pciutils
          perl
          smartmontools
          systemd
          util-linux
        ]
        ++ lib.optional enableRDW networkmanager
        ++ lib.optional enablePD glib
        ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform x86_energy_perf_policy) x86_energy_perf_policy
      );
    in
    ''
      fixup_perl=(
        $out/share/tlp/tlp-pcilist
        $out/share/tlp/tlp-readconfs
        $out/share/tlp/tlp-usblist
      )
      for f in "''${fixup_perl[@]}"; do
        wrapProgram "$f" --prefix PATH : "${paths}"
      done

      fixup_bash=(
        $out/bin/*
        $out/etc/NetworkManager/dispatcher.d/*
        $out/lib/udev/tlp-*
        $out/sbin/*
        $out/share/tlp/bat.d/*
        $out/share/tlp/func.d/*
        $out/share/tlp/tlp-func-base
      )
      for f in "''${fixup_bash[@]}"; do
        [[ "$f" =~ bin/(tlp-pd|tlpctl)$ ]] && continue
        sed -i '2iexport PATH=${paths}:$PATH' "$f"
      done

      rm -rf $out/var
      rm -rf $out/share/metainfo
    ''
    + lib.optionalString enablePD ''
      wrapProgram $out/sbin/tlp-pd --prefix PATH : "$out/bin"
    '';

  meta = {
    description = "Advanced Power Management for Linux";
    homepage = "https://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html";
    changelog = "https://github.com/linrunner/TLP/releases/tag/${version}";
    platforms = lib.platforms.linux;
    mainProgram = "tlp";
    maintainers = with lib.maintainers; [
      lovesegfault
    ];
    license = lib.licenses.gpl2Plus;
  };
}
