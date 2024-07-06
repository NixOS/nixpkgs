{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "testkube";
  version = "1.10.40";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6U9tbn1hp4OEI5ZNcknXBm64nJtZtC9nuIpsHSl1rQw=";
  };

  subPackages = [ "cmd/kubectl-testkube/main.go" ];

  vendorSha256 = "sha256-DLh4uKT4/YbA0ZjEZXmryyB5BnlL2XD+8JvHy+Su6pM=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv $out/bin/main $out/bin/kubectl-testkube
  '';

  meta = with lib; {
    description = "Kubernetes-native testing framework for test execution and orchestration";
    homepage = "https://testkube.io/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mausch ];
  };
}
