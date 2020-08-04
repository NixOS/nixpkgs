{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "antibody";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "0ldvihpm14h0gcn7iz5yxg1wbfv24flx6y8khdanw21lf9nmp59z";
  };

  vendorSha256 = "0z8fma3v2dph8nv3q4lmv43s6p5sc338xb7kcmnpwcc0iw7b4vyj";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = "https://github.com/getantibody/antibody";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 worldofpeace ];
  };
}
