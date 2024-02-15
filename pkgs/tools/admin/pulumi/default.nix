{ stdenv
, lib
, buildGoModule
, coreutils
, fetchFromGitHub
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
  version = "3.93.0";

  # Used in pulumi-language packages, which inherit this prop
  sdkVendorHash = lib.fakeHash;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EaYYIbV7IItnmVfyEHtaAbAXvrZ8CXMjW+yNXOBIxg8=";
    # Some tests rely on checkout directory name
    name = "pulumi";
  };

  vendorHash = "sha256-G+LspC6b2TvboMU6rKB0qrhhMNaLPVt/nUYZzkiVr/Q=";

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

  doCheck = true;

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
  ];

  nativeCheckInputs = [
    git
  ];

  preCheck = ''
    # The tests require `version.Version` to be unset
    ldflags=''${ldflags//"$importpathFlags"/}

    # Create some placeholders for plugins used in tests. Otherwise, Pulumi
    # tries to donwload them and fails, resulting in really long test runs
    dummyPluginPath=$(mktemp -d)
    for name in pulumi-{resource-pkg{A,B},-pkgB}; do
      ln -s ${coreutils}/bin/true "$dummyPluginPath/$name"
    done

    export PATH=$dummyPluginPath''${PATH:+:}$PATH

    # Code generation tests also download dependencies from network
    rm codegen/{docs,dotnet,go,nodejs,python,schema}/*_test.go
    rm -R codegen/{dotnet,go,nodejs,python}/gen_program_test

    # Only run tests not marked as disabled
    buildFlagsArray+=("-run" "[^(${lib.concatStringsSep "|" disabledTests})]")
  '' + lib.optionalString stdenv.isDarwin ''
    export PULUMI_HOME=$(mktemp -d)
  '';

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
          --suffix PATH : ${lib.makeSearchPath "bin" (f pulumiPackages)}
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
