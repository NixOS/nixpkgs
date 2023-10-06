{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-AG5CNqkxPQJQ+HN3JGUIgSYxgFigmUqVGn1yAHmo7Mo=";
  };

  vendorHash = "sha256-OLT85GOcTnWmU+ZRem2+vY29nzvzXhnmIN2W+U6phPk=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
