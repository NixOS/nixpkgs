{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubepug";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "rikatz";
    repo = "kubepug";
    rev = "v${version}";
    sha256 = "094c1qfmsdmy963bxs6lq3xh1zpfdfh16vlhfwi9yywmgcynb3b6";
  };

  vendorSha256 = "0jzry4znq4kcl6i9jcawilyjm8av1zxbml6nlr96v8x47ijxav5j";

  buildFlagsArray = ''
    -ldflags=-s -w -X=github.com/rikatz/kubepug/version.Version=${src.rev}
  '';

  subPackages = [ "cmd/kubepug.go" ];

  meta = with lib; {
    description = "Checks a Kubernetes cluster for objects using deprecated API versions";
    homepage = "https://github.com/rikatz/kubepug";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
