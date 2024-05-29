{ lib
, fetchFromGitHub
, buildGhidraExtension
, ghidra
}:
buildGhidraExtension {
  pname = "ret-sync-ghidra";
  version = "unstable-2024-05-29";

  src = fetchFromGitHub {
    owner = "bootleg";
    repo = "ret-sync";
    rev = "0617c75746ddde7fe2bdbbf880175af8ad27553e";
    sha256 = "sha256-+G5ccdHnFL0sHpueuIYwLRU9FhzN658CYqQCHCBwxV4=";
  };

  preBuild = ''
    cd ext_ghidra
  '';

  preInstall = ''
    correct_version=$(ls dist | grep ${ghidra.version})
    mv dist/$correct_version dist/safe.zip
    rm dist/ghidra*
    mv dist/safe.zip dist/$correct_version
    ls dist
  '';
  meta = with lib; {
    description = "Reverse-Engineering Tools SYNChronization. Allows syncing between a debugging session and Ghidra";
    homepage = "https://github.com/bootleg/ret-sync";
    license = licenses.gpl3Only;
  };
}
