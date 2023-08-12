{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bomber-go";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "devops-kung-fu";
    repo = "bomber";
    rev = "refs/tags/v${version}";
    hash = "sha256-q30wTM8HQURDBUReQsXgKHI4m4sSdHbWPwUld0sAays=";
  };

  vendorHash = "sha256-tkjwnc5EquAuIfYKy8u6ZDFJPl/UTW6x7vvY1QTsBXg=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool to scans Software Bill of Materials (SBOMs) for vulnerabilities";
    homepage = "https://github.com/devops-kung-fu/bomber";
    changelog = "https://github.com/devops-kung-fu/bomber/releases/tag/v${version}";
    license = licenses.mpl20;
    mainProgram = "bomber";
    maintainers = with maintainers; [ fab ];
  };
}
