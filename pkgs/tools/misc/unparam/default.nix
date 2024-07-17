{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "unparam";
  version = "unstable-2023-03-12";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "unparam";
    rev = "e84e2d14e3b88193890ff95d72ecb81312f36589";
    sha256 = "sha256-kbEdOqX/p/FrNfWQ2WjXX+lERprSV2EI9l+kapHuFi4=";
  };

  vendorHash = "sha256-gEZFAMcr1okqG2IXcS3hDzZKMINohd2JzxezGbzyeBE=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Find unused parameters in Go";
    homepage = "https://github.com/mvdan/unparam";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "unparam";
  };
}
