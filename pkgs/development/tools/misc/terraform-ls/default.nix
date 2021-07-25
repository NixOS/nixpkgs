{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ag8Dq3lhLoKE4rgrnWLHtKRHEnw/ytyXI+pRt5CgZJI=";
  };
  vendorSha256 = "sha256-/lpjlThr6HPkuJ6om9ifBsdsh0x4kVXM6PAonk7GJCY=";

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
