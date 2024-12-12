{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makePerlPath,

  # Perl libraries
  LWP,
  LWPProtocolHttps,
  HTTPMessage,
  HTTPDate,
  URI,
  TryTiny,

  # Required
  coreutils,
  curl, # Preferred to using the Perl HTTP libs - according to hw-probe.
  dmidecode,
  edid-decode,
  gnugrep,
  gnutar,
  hwinfo,
  iproute2,
  kmod,
  pciutils,
  perl,
  smartmontools,
  usbutils,
  xz,

  # Conditionally recommended
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,

  # Recommended
  withRecommended ? true, # Install recommended tools
  mcelog,
  hdparm,
  acpica-tools,
  drm_info,
  mesa-demos,
  memtester,
  sysstat,
  cpuid,
  util-linuxMinimal,
  xinput,
  libva-utils,
  inxi,
  vulkan-tools,
  i2c-tools,
  opensc,

  # Suggested
  withSuggested ? false, # Install (most) suggested tools
  hplip,
  sane-backends,
# , pnputils # pnputils (lspnp) isn't currently in nixpkgs and appears to be poorly maintained
}:

stdenv.mkDerivation rec {
  pname = "hw-probe";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "linuxhw";
    repo = pname;
    rev = version;
    sha256 = "sha256-WlLSgjVLqGGtwCyyUn9X3XbE2Yhz6LD245+U2JgGd+k=";
  };

  makeFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  makeWrapperArgs =
    let
      requiredPrograms = [
        hwinfo
        dmidecode
        smartmontools
        pciutils
        usbutils
        edid-decode
        iproute2 # (ip)
        coreutils # (sort)
        gnugrep
        curl
        gnutar
        xz
        kmod # (lsmod)
      ];
      recommendedPrograms =
        [
          mcelog
          hdparm
          acpica-tools
          drm_info
          mesa-demos
          memtester
          sysstat # (iostat)
          util-linuxMinimal # (rfkill)
          xinput
          libva-utils # (vainfo)
          inxi
          vulkan-tools
          i2c-tools
          opensc
        ]
        # cpuid is only compatible with i686 and x86_64
        ++ lib.optional (lib.elem stdenv.hostPlatform.system cpuid.meta.platforms) cpuid;
      conditionallyRecommendedPrograms = lib.optional systemdSupport systemd; # (systemd-analyze)
      suggestedPrograms = [
        hplip # (hp-probe)
        sane-backends # (sane-find-scanner)
        # pnputils # (lspnp)
      ];
      programs =
        requiredPrograms
        ++ conditionallyRecommendedPrograms
        ++ lib.optionals withRecommended recommendedPrograms
        ++ lib.optionals withSuggested suggestedPrograms;
    in
    [
      "--set"
      "PERL5LIB"
      "${makePerlPath [
        LWP
        LWPProtocolHttps
        HTTPMessage
        URI
        HTTPDate
        TryTiny
      ]}"
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath programs}"
    ];

  postInstall = ''
    wrapProgram $out/bin/hw-probe \
      $makeWrapperArgs
  '';

  meta = with lib; {
    description = "Probe for hardware, check operability and find drivers";
    homepage = "https://github.com/linuxhw/hw-probe";
    platforms = with platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
    license = with licenses; [
      lgpl21
      bsdOriginal
    ];
    maintainers = with maintainers; [ rehno-lindeque ];
    mainProgram = "hw-probe";
  };
}
