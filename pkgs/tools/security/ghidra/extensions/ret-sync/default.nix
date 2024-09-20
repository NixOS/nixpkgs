{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
  ghidra,
}:
buildGhidraExtension {
  pname = "ret-sync-ghidra";
  version = "0-unstable-2024-05-29";

  src = fetchFromGitHub {
    owner = "bootleg";
    repo = "ret-sync";
    rev = "0617c75746ddde7fe2bdbbf880175af8ad27553e";
    hash = "sha256-+G5ccdHnFL0sHpueuIYwLRU9FhzN658CYqQCHCBwxV4=";
  };

  preConfigure = ''
    cd ext_ghidra
  '';
  preInstall = ''
    correct_version=$(ls dist | grep ${ghidra.version})
    mv dist/$correct_version dist/safe.zip
    rm dist/ghidra*
    mv dist/safe.zip dist/$correct_version
  '';
  meta = with lib; {
    description = "Reverse-Engineering Tools SYNChronization. Allows syncing between a debugging session and Ghidra";
    homepage = "https://github.com/bootleg/ret-sync";
    license = licenses.gpl3Only;
  };
}
