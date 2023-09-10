{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9FxQ/Y2vMyc4gLbKjhts36wtBIt90gkQZ9LQ3FO/Jig=";
  };

  vendorHash = "sha256-HWwZd5AUo1cysT4WYylQ2+JPBBr/qYNVC4JcJyUiBag=";

  meta = with lib; {
    description = "A command line editor for HCL";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
