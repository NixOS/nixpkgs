{ lib, stdenv, fetchFromGitHub, perl, perlPackages, makeWrapper
, ps, dnsutils # dig is recommended for multiple categories
, withRecommends ? false # Install (almost) all recommended tools (see --recommends)
, withRecommendedSystemPrograms ? withRecommends, util-linuxMinimal, dmidecode
, file, hddtemp, iproute, ipmitool, usbutils, kmod, lm_sensors, smartmontools
, binutils, tree, upower, pciutils
, withRecommendedDisplayInformationPrograms ? withRecommends, glxinfo, xorg
}:

let
  prefixPath = programs:
    "--prefix PATH ':' '${lib.makeBinPath programs}'";
  recommendedSystemPrograms = lib.optionals withRecommendedSystemPrograms [
    util-linuxMinimal dmidecode file hddtemp iproute ipmitool usbutils kmod
    lm_sensors smartmontools binutils tree upower pciutils
  ];
  recommendedDisplayInformationPrograms = lib.optionals
    withRecommendedDisplayInformationPrograms
    ([ glxinfo ] ++ (with xorg; [ xdpyinfo xprop xrandr ]));
  programs = [ ps dnsutils ] # Core programs
    ++ recommendedSystemPrograms
    ++ recommendedDisplayInformationPrograms;
in stdenv.mkDerivation rec {
  pname = "inxi";
  version = "3.3.01-1";

  src = fetchFromGitHub {
    owner = "smxi";
    repo = "inxi";
    rev = version;
    sha256 = "sha256-wY9wsxBByxqy9qk/7UoKiUSpFGS1rFpdyTs3ig6OJRs=";
  };

  buildInputs = [ perl makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp inxi $out/bin/
    wrapProgram $out/bin/inxi \
      --set PERL5LIB "${perlPackages.makePerlPath (with perlPackages; [ CpanelJSONXS ])}" \
      ${prefixPath programs}
    mkdir -p $out/share/man/man1
    cp inxi.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "A full featured CLI system information tool";
    longDescription = ''
      inxi is a command line system information script built for console and
      IRC. It is also used a debugging tool for forum technical support to
      quickly ascertain users' system configurations and hardware. inxi shows
      system hardware, CPU, drivers, Xorg, Desktop, Kernel, gcc version(s),
      Processes, RAM usage, and a wide variety of other useful information.
    '';
    homepage = "https://smxi.org/docs/inxi.htm";
    changelog = "https://github.com/smxi/inxi/blob/${version}/inxi.changelog";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
