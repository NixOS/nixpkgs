{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.16.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-1j7qgMTb9uz261mI8adY9aM8BkCFQHCCjuc8RIDcqCg=";
  };
  vendorHash = "sha256-A7FsCfZQKFFrk0KXvgyJjfGjyHQ3Ruoq/+RxC+zSa04=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
