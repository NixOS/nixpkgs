{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gh-ost";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-ost";
    rev = "v${version}";
    sha256 = "0laj5nmf10qn01mqn0flipmhankgvrcfbdl3bc76wa14qkkg722m";
  };

  goPackagePath = "github.com/github/gh-ost";

  buildFlagsArray = [ "-ldflags=-s -w -X main.AppVersion=${version} -X main.BuildDescribe=${src.rev}" ];

  meta = with stdenv.lib; {
    description = "Triggerless online schema migration solution for MySQL";
    homepage = "https://github.com/github/gh-ost";
    license = licenses.mit;
  };
}
