{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2019.2.1";

  goPackagePath = "honnef.co/go/tools";
  excludedPackages = ''\(simple\|ssa\|ssa/ssautil\|lint\|staticcheck\|stylecheck\|unused\)/testdata'';

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "1frpy4pl9yp6j00mjj2yss3k8hip0cc7b5i5mz61n3dlw0kga9z1";
  };

  modSha256 = "0ysaq94m7pkziliz4z4dl8ad84mbn17m2hqxvs9wbw4iwhkpi7gz";

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis.";
    homepage = https://staticcheck.io;
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}
