{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "controller-tools";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eAt9LaFtnRlk6L0m6ubXUVY8CsIsiHY4pxCFU7KkNpk=";
  };

  vendorSha256 = "sha256-R48IRSmDgESnYIhWINu6yMSwKF25CqgdYHzfzUbjmrU=";

  meta = with lib; {
    description = "Tools to use with the kubernetes-sigs controller-runtime libraries";
    longDescription = ''
      The Kubernetes controller-tools Project is a set of go libraries for building Controllers.
    '';
    homepage = "https://github.com/kubernetes-sigs/controller-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ raboof ];
  };
}
