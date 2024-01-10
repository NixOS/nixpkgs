{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goimports-reviser";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "incu6us";
    repo = "goimports-reviser";
    rev = "v${version}";
    hash = "sha256-bN8bj/JW7Wixv0MUNC43gpjJUndon5twL96axticnIU=";
  };
  vendorHash = "sha256-aYhUsO3Z0uue66XB+/oSVYLG9QGyVcFeZ0ngzhpBZxo=";

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
    homepage = "https://github.com/incu6us/goimports-reviser";
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
  };
}
