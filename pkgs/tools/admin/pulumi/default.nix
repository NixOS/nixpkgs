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
  version = "3.122.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5KHptoQliqPtJ6J5u23ZgRZOdO77BJhZbdc3Cty9Myk=";
    # Some tests rely on checkout directory name
    name = "pulumi";
  };

  vendorHash = "sha256-1UyYbmNNHlAeaW6M6AkaQ5Hs25ziHenSs4QjlnUQGjs=";

  patches = [
    # Fix a test failure, can be dropped in next release (3.100.0)
    (fetchpatch {
      url = "https://github.com/pulumi/pulumi/commit/6dba7192d134d3b6f7e26dee9205711ccc736fa7.patch";
      hash = "sha256-QRN6XnIR2rrqJ4UFYNt/YmIlokTSkGUvnBO/Q9UN8X8=";
      stripLen = 1;
    })
  ];

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
    # tries to donwload them and fails, resulting in really long test runs
    dummyPluginPath=$(mktemp -d)
    for name in pulumi-{resource-pkg{A,B},-pkgB}; do
      ln -s ${coreutils}/bin/true "$dummyPluginPath/$name"
    done

    export PATH=$dummyPluginPath''${PATH:+:}$PATH

    # Code generation tests also download dependencies from network
    rm codegen/{docs,dotnet,go,nodejs,python,schema}/*_test.go
    rm -R codegen/{dotnet,go,nodejs,python}/gen_program_test

  '' + lib.optionalString stdenv.isDarwin ''
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
          --set LD_LIBRARY_PATH "${stdenv.cc.cc.lib}/lib
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
