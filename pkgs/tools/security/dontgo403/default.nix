{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dontgo403";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = pname;
    rev = version;
    hash = "sha256-QHkmnhOLdyci3PAhf/JIiYlCta8DJ3cZb1S6Sim0qGQ=";
  };

  vendorSha256 = "sha256-jF+CSmLHMdlFpttYf3pK84wdfFAHSVPAK8S5zunUzB0=";

  meta = with lib; {
    description = "Tool to bypass 40X response codes";
    homepage = "https://github.com/devploit/dontgo403";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
