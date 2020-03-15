{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2020.1.3";

  excludedPackages = ''\(simple\|ssa\|ssa/ssautil\|lint\|staticcheck\|stylecheck\|unused\)/testdata'';

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "0pvi1mzhy6zgx4zfgdypbl4zhvgg11hl5qv7blf2qs0a96j2djhf";
  };

  modSha256 = "03560xjr2531xj87paskfx2zs364fz6y4kpsid8x08s1syq9nq7p";

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = https://staticcheck.io;
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}
