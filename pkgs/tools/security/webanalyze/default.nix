{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "webanalyze";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "rverton";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-r5HIXh0mKCZmzOOAKThNUPtJLsTYvnVE8FYA6vV5xjg=";
  };

  vendorSha256 = "sha256-kXtWYGsZUUhBNvkTOah3Z+ta118k6PXfpBx6MLr/pq0=";

  meta = with lib; {
    description = "Tool to uncover technologies used on websites";
    homepage = "https://github.com/rverton/webanalyze";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
