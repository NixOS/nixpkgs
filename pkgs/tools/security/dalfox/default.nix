{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7wSmPmS8m+rYhYlREzKlPUiUfDvru9zwFFvSCDq6JY8=";
  };

  vendorHash = "sha256-W+37EL3e7G+U0EZUDuVqjZpfIf5+HcirH8NVsC+1NvA=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dalfox";
  };
}
