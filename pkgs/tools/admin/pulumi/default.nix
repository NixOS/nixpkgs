{ stdenv
, lib
, buildGoModule
, coreutils
, fetchFromGitHub
, fetchpatch
, installShellFiles
, git
  # passthru
, runCommand
, makeWrapper
, pulumi
, pulumiPackages
}:

buildGoModule rec {
  pname = "pulumi";
  version = "3.137.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U1BubJIqQu+tAYQz8ojVrJpx6ZbMFEarSCmmuahG6ys=";
    # Some tests rely on checkout directory name
    name = "pulumi";
  };

  vendorHash = "sha256-Q9NTlgd+rOD5vmbmeAepIARvFtNQT/IFLPeaFC74E7c=";

  sourceRoot = "${src.name}/pkg";

  nativeBuildInputs = [ installShellFiles ];

  # Bundle release metadata
  ldflags = [
    # Omit the symbol table and debug information.
    "-s"
    # Omit the DWARF symbol table.
    "-w"
  ] ++ importpathFlags;

  importpathFlags = [
    "-X github.com/pulumi/pulumi/pkg/v3/version.Version=v${version}"
  ];

  nativeCheckInputs = [
    git
  ];

  preCheck = ''
    # The tests require `version.Version` to be unset
    ldflags=''${ldflags//"$importpathFlags"/}

    # Create some placeholders for plugins used in tests. Otherwise, Pulumi
    # tries to donwload them and fails, resulting in really long test runs.
    # This has to be linked to the cwd, otherwise tests will fail and a
    # warning will be emitted noting that the plugin was located in $PATH.
    for name in pulumi-{resource-pkg{A,B},-pkgB}; do
      ln -s ${coreutils}/bin/true "$name"
    done

    # Code generation tests also download dependencies from network
    rm codegen/{docs,dotnet,go,nodejs,python,schema}/*_test.go
    # Azure tests are not being skipped when an Azure token is not provided
    rm secrets/cloud/azure_test.go
    rm -R codegen/{dotnet,go,nodejs,python}/gen_program_test

    unset PULUMI_ACCESS_TOKEN
    export PULUMI_DISABLE_AUTOMATIC_PLUGIN_ACQUISITION=true
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export PULUMI_HOME=$(mktemp -d)
  '';

  checkFlags =
    let
      disabledTests = [
        # Flaky test
        "TestPendingDeleteOrder"
        # Tries to clone repo: github.com/pulumi/templates.git
        "TestGenerateOnlyProjectCheck"
        # Following tests give this error, not quite sure why:
        #     Error Trace:    /build/pulumi/pkg/engine/lifecycletest/update_plan_test.go:273
        # Error:          Received unexpected error:
        #                 Unexpected diag message: <{%reset%}>using pulumi-resource-pkgA from $PATH at /build/tmp.bS8caxmTx7/pulumi-resource-pkgA<{%reset%}>
        # Test:           TestUnplannedDelete
        "TestExpectedDelete"
        "TestPlannedInputOutputDifferences"
        "TestPlannedUpdateChangedStack"
        "TestExpectedCreate"
        "TestUnplannedDelete"
        # Following test gives this  error, not sure why:
        # --- Expected
        # +++ Actual
        # @@ -1 +1 @@
        # -gcp
        # +aws
        "TestPluginMapper_MappedNamesDifferFromPulumiName"
        "TestProtect"
        "TestProgressEvents"
        # This test depends on having a PULUMI_ACCESS_TOKEN but is not skipped when one is not provided.
        # Other tests are skipped when the env var is missing. I guess they forgot about this one.
        "TestPulumiNewSetsTemplateTag"
        # Both tests require having a "pulumi-language-yaml" plugin installed since pulumi/pulumi#17285,
        # which I'm not sure how to add.
        "TestProjectNameDefaults"
        "TestProjectNameOverrides"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" disabledTests}$" ];

  # Allow tests that bind or connect to localhost on macOS.
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  installCheckPhase = ''
    PULUMI_SKIP_UPDATE_CHECK=1 $out/bin/pulumi version | grep v${version} > /dev/null
  '';

  postInstall = ''
    installShellCompletion --cmd pulumi \
      --bash <($out/bin/pulumi gen-completion bash) \
      --fish <($out/bin/pulumi gen-completion fish) \
      --zsh  <($out/bin/pulumi gen-completion zsh)
  '';

  passthru = {
    pkgs = pulumiPackages;
    withPackages = f: runCommand "${pulumi.name}-with-packages"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${pulumi}/bin/pulumi $out/bin/pulumi \
          --suffix PATH : ${lib.makeBinPath (f pulumiPackages)} \
          --set LD_LIBRARY_PATH "${stdenv.cc.cc.lib}/lib"
      '';
  };

  meta = with lib; {
    homepage = "https://pulumi.io/";
    description = "Pulumi is a cloud development platform that makes creating cloud programs easy and productive";
    sourceProvenance = [ sourceTypes.fromSource ];
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      trundle
      veehaitch
    ];
  };
}
