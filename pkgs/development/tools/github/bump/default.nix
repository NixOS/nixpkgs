{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bump";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "mroth";
    repo = pname;
    rev = "v${version}";
    sha256 = "0092jn7nxnr64fyb2yy9amrd8gl7q9p70a2yq9jrgr1pyrlrazbq";
  };

  vendorSha256 = "0w5sqg1ii4vp7iijs6ffbskkj2xqggbr40j6wxrjrbjr1qisl8r1";

  doCheck = false;

  ldflags = [
    "-X main.buildVersion=${version}" "-X main.buildCommit=${version}" "-X main.buildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/mroth/bump";
    description = "CLI tool to draft a GitHub Release for the next semantic version";
    maintainers = with maintainers; [ doronbehar ];
  };
}
