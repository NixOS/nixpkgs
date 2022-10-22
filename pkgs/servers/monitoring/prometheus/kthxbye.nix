{ pkgs
, lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "kthxbye";
  version = "0.15";

  src = fetchFromGitHub rec {
    owner = "prymitive";
    repo = "kthxbye";
    rev = "v${version}";
    hash = "sha256-N1MzutjzLk9MnE1b7dKRsiS7LL4Nb61+NpmjTBPGohI=";
  };

  vendorHash = "sha256-PtINxblqX/wxJyN42mS+hmwMy0lCd6FcQgmBnxTUdcc=";

  buildPhase = ''
    make -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    install -Dm755 ./kthxbye -t $out/bin
  '';

  passthru.tests = {
    kthxbye = nixosTests.kthxbye;
  };

  meta = with lib; {
    description = "Prometheus Alertmanager alert acknowledgement management daemon";
    homepage = "https://github.com/prymitive/kthxbye";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
  };
}
