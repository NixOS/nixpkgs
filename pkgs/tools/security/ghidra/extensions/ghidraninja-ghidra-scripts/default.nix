{
  lib,
  fetchFromGitHub,
  buildGhidraScripts,
  binwalk,
  swift,
  yara,
  useSwift ? false,
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
    substituteInPlace binwalk.py --replace-fail 'subprocess.call(["binwalk"' 'subprocess.call(["${lib.getExe binwalk}"'
    substituteInPlace yara.py --replace-fail 'subprocess.check_output(["yara"' 'subprocess.check_output(["${lib.getExe yara}"'
    substituteInPlace YaraSearch.py --replace-fail '"yara "' '"${lib.getExe yara} "'
  ''
  + (
    if useSwift then
      ''
        substituteInPlace swift_demangler.py --replace-fail '"swift"' '"${lib.getExe' swift "swift"}"'
      ''
    else
      ''
        rm swift_demangler.py
      ''
  );

  meta = {
    description = "Scripts for the Ghidra software reverse engineering suite";
    homepage = "https://github.com/ghidraninja/ghidra_scripts";
    license = with lib.licenses; [
      gpl3Only
      gpl2Only
    ];
  };
}
