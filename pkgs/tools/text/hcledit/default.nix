{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hunM29K6RgeVkY8nNNIYigCh2sTCR1OyPE+k3cmIJTU=";
  };

  vendorHash = "sha256-KwoauyXeDMMTUgtLvz6m28nvFSl5fptZzEvwFVC3n8g=";

  meta = with lib; {
    description = "A command line editor for HCL";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
