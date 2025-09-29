{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.37";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = "sha256-PZ+8hlxSwayR1yvjHmStMDur9e1uc2s+YB8qdz+42mA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-VeB0A+freNwgETQMIokiOPWovGq1FANUexnzxVg2aRA=";

  preBuild = ''
    go mod tidy
  '';

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    ./build
    ./functional/build
    runHook postBuild
  '';

  doCheck = false;

  postInstall = ''
    install -Dm755 bin/* bin/functional/cmd/* -t $out/bin
  '';

  meta = {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    downloadPage = "https://github.com/etcd-io/etcd/";
    license = lib.licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = [ ];
  };
}
