{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dirstalk";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "stefanoj3";
    repo = pname;
    rev = version;
    hash = "sha256-gSMkTGzMDI+scG3FQ0u0liUDL4qOPPW2UWLlAQcmmaA=";
  };

  vendorHash = "sha256-nesKIaMMuN71LpvX8nOm7hDecgGjnx3tmsinrJg4GpQ=";

  subPackages = "cmd/dirstalk";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/stefanoj3/dirstalk/pkg/cmd.Version=${version}"
  ];

  # Tests want to write to the root directory
  doCheck = false;

  meta = with lib; {
    description = "Tool to brute force paths on web servers";
    homepage = "https://github.com/stefanoj3/dirstalk";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
