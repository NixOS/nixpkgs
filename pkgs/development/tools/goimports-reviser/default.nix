{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goimports-reviser";
  version = "3.6.5";

  src = fetchFromGitHub {
    owner = "incu6us";
    repo = "goimports-reviser";
    rev = "v${version}";
    hash = "sha256-46s6A1sGqoJR3XihaCkVCxTpManl330mMcJ8hv66zDc=";
  };
  vendorHash = "sha256-z+FeAXPXKi653im2X2WOP1R9gRl/x7UBnndoEXoxdwA=";

  CGO_ENABLED = 0;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Tag=${src.rev}"
  ];

  checkFlags = [
    "-skip=TestSourceFile_Fix_WithAliasForVersionSuffix/success_with_set_alias"
  ];

  preCheck = ''
    # unset to run all tests
    unset subPackages
    # unset as some tests require cgo
    unset CGO_ENABLED
  '';

  meta = with lib; {
    description = "Right imports sorting & code formatting tool (goimports alternative)";
    mainProgram = "goimports-reviser";
    homepage = "https://github.com/incu6us/goimports-reviser";
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
  };
}
