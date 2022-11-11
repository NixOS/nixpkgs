{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "webanalyze";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "rverton";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W7NgV50r/MNSF6+e0IR9C1dcg/k0w67GcTs0NTbhKBc=";
  };

  vendorSha256 = "sha256-kXtWYGsZUUhBNvkTOah3Z+ta118k6PXfpBx6MLr/pq0=";

  meta = with lib; {
    description = "Tool to uncover technologies used on websites";
    homepage = "https://github.com/rverton/webanalyze";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
