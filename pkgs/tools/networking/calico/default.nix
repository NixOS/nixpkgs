{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "calico";
  version = "3.19.1";

  src = fetchFromGitHub {
    owner = "projectcalico";
    repo = "cni-plugin";
    rev = "v${version}";
    sha256 = "sha256-k314oe0P49Ki+cI/ejKLflnntyUX0rYMZM6pEaPrMwI=";
  };

  vendorSha256 = "sha256-DT/P1bcxp6mwdgtooGcnG/4JIBIxeRudwy+tzYTZxsE=";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X main.VERSION=v${version}")
  '';

  # calico changes it's behaviour based on it's name, coreutils single binary style.
  postInstall = ''
    ln -s $out/bin/calico $out/bin/calico-ipam
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/calico --help
    $out/bin/calico -v | grep "v${version}"
    $out/bin/calico-ipam --help
    $out/bin/calico-ipam -v | grep "v${version}"
    runHook postInstallCheck
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.projectcalico.org/";
    changelog = "https://docs.projectcalico.org/release-notes/";
    description = "Cloud native networking and network security";
    longDescription = ''
      Calico is an open source networking and network security solution for
      containers, virtual machines, and native host-based workloads. Calico
      supports a broad range of platforms including Kubernetes, OpenShift,
      Docker EE, OpenStack, and bare metal services.

      Whether you opt to use Calico's eBPF data plane or Linux’s standard
      networking pipeline, Calico delivers blazing fast performance with true
      cloud-native scalability. Calico provides developers and cluster operators
      with a consistent experience and set of capabilities whether running in
      public cloud or on-prem, on a single node, or across a multi-thousand node
      cluster.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
