{
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  patches = [
    # This patch is needed to get the extension compiling with Ghidra 11.2.
    # Once it's fixed upstream, the src can be updated and this can be removed.
    (fetchpatch {
      # https://github.com/bootleg/ret-sync/pull/126
      name = "ghidra-11.2-fix.patch";
      url = "https://github.com/bootleg/ret-sync/commit/d81d953c24b4369b499e90ba64c1c9f78513a008.patch";
      hash = "sha256-t/voPcBfsZtfdYnskgBAPfqMTBw1LRTT0aXyyb5qtr8=";
    })
  ];
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
