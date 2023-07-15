{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "webanalyze";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "rverton";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1z4hi9a/OzBXIMBk1f0JpPMV/kRgBnTQAEygIZqV+1w=";
  };

  vendorHash = "sha256-kXtWYGsZUUhBNvkTOah3Z+ta118k6PXfpBx6MLr/pq0=";

  meta = with lib; {
    description = "Tool to uncover technologies used on websites";
    homepage = "https://github.com/rverton/webanalyze";
    changelog = "https://github.com/rverton/webanalyze/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
