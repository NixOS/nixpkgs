{
  acpica-tools,
  bash,
  bc,
  coreutils,
  fetchFromGitHub,
  gawk,
  gnugrep,
  gnused,
  linuxPackages,
  lib,
  pciutils,
  powertop,
  resholve,
  util-linux,
  xorg,
  xxd,
}:
resholve.mkDerivation {
  pname = "s0ix-selftest-tool";
  version = "unstable-2022-11-04";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "S0ixSelftestTool";
    rev = "1b6db3c3470a3a74b052cb728a544199661d18ec";
    hash = "sha256-w97jfdppW8kC8K8XvBntmkfntIctXDQCWmvug+H1hKA=";
  };

  # don't use the bundled turbostat binary
  postPatch = ''
    substituteInPlace s0ix-selftest-tool.sh --replace '"$DIR"/turbostat' 'turbostat'
    substituteInPlace s0ix-selftest-tool.sh --replace 'sudo ' ""

  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 s0ix-selftest-tool.sh "$out/bin/s0ix-selftest-tool"
    runHook postInstall
  '';

  solutions = {
    default = {
      scripts = ["bin/s0ix-selftest-tool"];
      interpreter = lib.getExe bash;
      inputs = [
        acpica-tools
        bc
        coreutils
        gawk
        gnugrep
        gnused
        linuxPackages.turbostat
        pciutils
        powertop
        util-linux
        xorg.xset
        xxd
      ];
      execer = [
        "cannot:${util-linux}/bin/dmesg"
        "cannot:${powertop}/bin/powertop"
        "cannot:${util-linux}/bin/rtcwake"
        "cannot:${linuxPackages.turbostat}/bin/turbostat"
      ];
    };
  };

  meta = with lib; {
    homepage = "https://github.com/intel/S0ixSelftestTool";
    description = "A tool for testing the S2idle path CPU Package C-state and S0ix failures";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [adamcstephens];
    mainProgram = "s0ix-selftest-tool";
  };
}
