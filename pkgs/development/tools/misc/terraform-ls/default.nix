{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d/dn77pV9qxzAm6NVOM5KhFxYi2/xEK02zMl2TTB5rA=";
  };
  vendorSha256 = "sha256-0PcMxotUEys+jGDFEEz6owbtTGAac+RwoBWEHP5ifKQ=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" "-X main.prerelease=" ];

  preCheck = ''
    # Remove tests that requires networking
    rm internal/terraform/exec/exec_test.go
  '' + lib.optionalString stdenv.isAarch64 ''
    # Not all test failures have tracking issues as HashiCorp do not have
    # aarch64 testing infra easily available, see issue 549 below.

    # Remove file that contains `TestLangServer_workspaceExecuteCommand_modules_multiple`
    # which fails on aarch64: https://github.com/hashicorp/terraform-ls/issues/549
    rm internal/langserver/handlers/execute_command_modules_test.go

    # `TestModuleManager_ModuleCandidatesByPath` variants fail
    rm internal/terraform/module/module_manager_test.go

    # internal/terraform/module/module_ops_queue_test.go:17:15: undefined: testLogger
    # internal/terraform/module/watcher_test.go:39:11: undefined: testLogger
    # internal/terraform/module/watcher_test.go:79:14: undefined: testLogger
    rm internal/terraform/module/{watcher_test,module_ops_queue_test}.go
  '';

  meta = with lib; {
    description = "Terraform Language Server (official)";
    homepage = "https://github.com/hashicorp/terraform-ls";
    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mbaillie jk ];
  };
}
