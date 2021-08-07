{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "antibody";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "0icag53svzdm7yvzp855fp0f7q0g0jkfmjaa1sj6mmb01c1xgzi1";
  };

  vendorSha256 = "0z8fma3v2dph8nv3q4lmv43s6p5sc338xb7kcmnpwcc0iw7b4vyj";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = "https://github.com/getantibody/antibody";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
