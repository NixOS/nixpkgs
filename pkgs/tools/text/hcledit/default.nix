{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y1v4VqbF23ah1MeBeFEjmNVfmA9DkMJZvulmy2kVdUI=";
  };

  vendorHash = "sha256-KwoauyXeDMMTUgtLvz6m28nvFSl5fptZzEvwFVC3n8g=";

  meta = with lib; {
    description = "A command line editor for HCL";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
