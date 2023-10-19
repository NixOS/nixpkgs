{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudlist";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-m0b7gtbI9i1tD8HduEAF+Mo2UpI4gqldEO8q4u+Wo3E=";
  };

  vendorHash = "sha256-GHQnI4T6y/p+BlQyrNJmIaSek0sC1J3UwcuvDQH5gCI=";

  meta = with lib; {
    description = "Tool for listing assets from multiple cloud providers";
    homepage = "https://github.com/projectdiscovery/cloudlist";
    changelog = "https://github.com/projectdiscovery/cloudlist/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
