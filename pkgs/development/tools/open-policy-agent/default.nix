{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,

  enableWasmEval ? false,
}:

assert
  enableWasmEval && stdenv.isDarwin
  -> builtins.throw "building with wasm on darwin is failing in nixpkgs";

buildGoModule rec {
  pname = "open-policy-agent";
  version = "0.64.1";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    rev = "v${version}";
    hash = "sha256-IIW6AXv5x+uQGCZulPPB7IhRlCq7Ww76qUhMHg3Fx7g=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/opa/version.Version=${version}"
  ];

  tags = lib.optional enableWasmEval (
    builtins.trace (
      "Warning: enableWasmEval breaks reproducability, "
      + "ensure you need wasm evaluation. "
      + "`opa build` does not need this feature."
    ) "opa_wasm"
  );

  checkFlags = lib.optionals (!enableWasmEval) [
    "-skip=TestRegoTargetWasmAndTargetPluginDisablesIndexingTopdownStages"
  ];

  preCheck =
    ''
      # Feed in all but the e2e tests for testing
      # This is because subPackages above limits what is built to just what we
      # want but also limits the tests
      # Also avoid wasm tests on darwin due to wasmtime-go build issues
      getGoDirs() {
        go list ./... | grep -v -e e2e ${lib.optionalString stdenv.isDarwin "-e wasm"}
      }
    ''
    + lib.optionalString stdenv.isDarwin ''
      # remove tests that have "too many open files"/"no space left on device" issues on darwin in hydra
      rm server/server_test.go
    '';

  postInstall = ''
    installShellCompletion --cmd opa \
      --bash <($out/bin/opa completion bash) \
      --fish <($out/bin/opa completion fish) \
      --zsh <($out/bin/opa completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/opa --help
    $out/bin/opa version | grep "Version: ${version}"

    ${lib.optionalString enableWasmEval ''
      # If wasm is enabled verify it works
      $out/bin/opa eval -t wasm 'trace("hello from wasm")'
    ''}

    runHook postInstallCheck
  '';

  meta = with lib; {
    mainProgram = "opa";
    homepage = "https://www.openpolicyagent.org";
    changelog = "https://github.com/open-policy-agent/opa/blob/v${version}/CHANGELOG.md";
    description = "General-purpose policy engine";
    longDescription = ''
      The Open Policy Agent (OPA, pronounced "oh-pa") is an open source, general-purpose policy engine that unifies
      policy enforcement across the stack. OPA provides a high-level declarative language that let’s you specify policy
      as code and simple APIs to offload policy decision-making from your software. You can use OPA to enforce policies
      in microservices, Kubernetes, CI/CD pipelines, API gateways, and more.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [
      lewo
      jk
    ];
  };
}
