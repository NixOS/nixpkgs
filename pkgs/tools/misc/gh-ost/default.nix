{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gh-ost";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-ost";
    rev = "v${version}";
    sha256 = "sha256-srJXzY4TTHZDYKq8OPqin4zRoYlmaJKhHXDzO/GjBV8=";
  };

  goPackagePath = "github.com/github/gh-ost";

  buildFlagsArray = [ "-ldflags=-s -w -X main.AppVersion=${version} -X main.BuildDescribe=${src.rev}" ];

  meta = with lib; {
    description = "Triggerless online schema migration solution for MySQL";
    homepage = "https://github.com/github/gh-ost";
    license = licenses.mit;
  };
}
