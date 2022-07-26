{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rakkess";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "corneliusweig";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qDcSIpIS09OU2tYoBGq7BCXFkf9QWj07RvNKMjghrFU=";
  };
  vendorSha256 = "sha256-1/8it/djhDjbWqe36VefnRu9XuwAa/qKpZT6d2LGpJ0=";

  ldflags = [ "-s" "-w" "-X github.com/corneliusweig/rakkess/internal/version.version=v${version}" ];

  meta = with lib; {
    homepage = "https://github.com/corneliusweig/rakkess";
    changelog = "https://github.com/corneliusweig/rakkess/releases/tag/v${version}";
    description = "Review Access - kubectl plugin to show an access matrix for k8s server resources";
    longDescription = ''
      Have you ever wondered what access rights you have on a provided
      kubernetes cluster? For single resources you can use
      `kubectl auth can-i list deployments`, but maybe you are looking for a
      complete overview? This is what rakkess is for. It lists access rights for
      the current user and all server resources, similar to
      `kubectl auth can-i --list`.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
