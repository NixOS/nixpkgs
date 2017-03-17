{ stdenv, lib, buildGoPackage, fetchFromGitHub, go-bindata }:

let
  version = "0.12.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes";
    repo = "minikube";
    sha256 = "18zif97qd10w4ps55pwfpc5fkgrprs5j01b0rv5yjwjkzakdcrdy";
  };

  localkube = buildGoPackage {
    inherit src;

    name = "localkube-${version}";
    goPackagePath = "k8s.io/minikube";
    subPackages = ["cmd/localkube"];

    buildInputs = [stdenv.glibc.static];

    buildFlagsArray = ''
      -ldflags=
        -extldflags "-static"
    '';
  };

in buildGoPackage {
  name = "minikube-${version}";

  inherit src;

  goPackagePath = "k8s.io/minikube";
  subPackages = ["cmd/minikube"];

  buildInputs = [go-bindata];

  preBuild = ''
    (cd go/src/k8s.io/minikube && mkdir out && cp ${localkube.bin}/bin/localkube ./out/localkube &&
     go-bindata -nomemcopy -o pkg/minikube/assets/assets.go -pkg assets ./out/localkube deploy/addons)
  '';

  postInstall = ''
    cp ${localkube.bin}/bin/localkube $bin/bin/localkube
  '';

  meta = with lib; {
    description = "Run Kubernetes locally";
    license = licenses.asl20;
    homepage = https://github.com/kubernetes/minikube;
    maintainers = with maintainers; [offline];
  };
}
