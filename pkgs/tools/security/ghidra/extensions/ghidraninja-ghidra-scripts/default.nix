{
  lib,
  fetchFromGitHub,
  buildGhidraScripts,
  binwalk,
  swift,
  yara,
}:

buildGhidraScripts {
  pname = "ghidraninja-ghidra-scripts";
  version = "unstable-2020-10-07";

  src = fetchFromGitHub {
    owner = "ghidraninja";
    repo = "ghidra_scripts";
    rev = "99f2a8644a29479618f51e2d4e28f10ba5e9ac48";
    sha256 = "aElx0mp66/OHQRfXwTkqdLL0gT2T/yL00bOobYleME8=";
  };

  postPatch = ''
    # Replace subprocesses with store versions
    substituteInPlace binwalk.py --replace-fail 'subprocess.call(["binwalk"' 'subprocess.call(["${binwalk}/bin/binwalk"'
    substituteInPlace swift_demangler.py --replace-fail '"swift"' '"${swift}/bin/swift"'
    substituteInPlace yara.py --replace-fail 'subprocess.check_output(["yara"' 'subprocess.check_output(["${yara}/bin/yara"'
    substituteInPlace YaraSearch.py --replace-fail '"yara "' '"${yara}/bin/yara "'
  '';

  meta = with lib; {
    description = "Scripts for the Ghidra software reverse engineering suite";
    homepage = "https://github.com/ghidraninja/ghidra_scripts";
    license = with licenses; [
      gpl3Only
      gpl2Only
    ];
  };
}
