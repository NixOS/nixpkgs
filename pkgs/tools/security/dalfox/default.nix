{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wNoZ8bXPnYO3qQO+Is5IRGukLj+QfA+xalKC6NVc5+0=";
  };

  vendorSha256 = "sha256-qaRUlgxGqZu5T3GHONT4MyHfHr/L6cqP7o0dV4OCOLY=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
