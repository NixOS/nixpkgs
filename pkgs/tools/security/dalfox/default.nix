{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+RCjudjbvc793sE2GCV/l23JD7ZqjNWhi7ZjUaCvTzw=";
  };

  vendorSha256 = "sha256-pLhTwbcMIqm7nrzypMs6yVrqtdCAoPrabTXsUtJ6Zls=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
