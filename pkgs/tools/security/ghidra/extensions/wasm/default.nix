{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
  ghidra,
  ant,
}:
buildGhidraExtension (finalAttrs: {
  pname = "wasm";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "nneonneo";
    repo = "ghidra-wasm-plugin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aoSMNzv+TgydiXM4CbvAyu/YsxmdZPvpkZkYEE3C+V4=";
  };

  nativeBuildInputs = [ ant ];

  configurePhase = ''
    runHook preConfigure

    # this doesn't really compile, it compresses sinc into sla
    pushd data
    ant -f build.xml -Dghidra.install.dir=${ghidra}/lib/ghidra sleighCompile
    popd

    runHook postConfigure
  '';

  meta = {
    description = "Ghidra Wasm plugin with disassembly and decompilation support";
    homepage = "https://github.com/nneonneo/ghidra-wasm-plugin";
    downloadPage = "https://github.com/nneonneo/ghidra-wasm-plugin/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/nneonneo/ghidra-wasm-plugin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.BonusPlay ];
  };
})
