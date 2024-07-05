{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UtZ59S8Cn29HNE9UpmJFtPkB8TMpDUOzlLMf78a+Vd4=";
  };

  vendorHash = "sha256-huDM8kPA6vQcoJTxiWzVFZKHrTKw1ip32hMZJYZM0og=";

  meta = with lib; {
    description = "Command line editor for HCL";
    mainProgram = "hcledit";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
