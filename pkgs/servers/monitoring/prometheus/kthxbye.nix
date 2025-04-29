{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "kthxbye";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "prymitive";
    repo = "kthxbye";
    rev = "v${version}";
    hash = "sha256-B6AgD79q0kA67iC9pIfv8PH8xejx2srpRccdds1GsZo=";
  };

  vendorHash = "sha256-BS9+2w18tvrgmPzRMP0XyUlyPAR9AJMLXUd3GYEJr8E=";

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
    mainProgram = "kthxbye";
    homepage = "https://github.com/prymitive/kthxbye";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
  };
}
