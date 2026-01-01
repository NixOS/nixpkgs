{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
<<<<<<< HEAD
  version = "10.2.0";
=======
  version = "10.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MlEscksRj3FR6tDzCZDaQ5iOhLubqvxYdXNH7HCcpfM=";
  };

  vendorHash = "sha256-83qUoQNiQ3D2Bm6D4DoVZDEO8EtUmxBXlpV6F+N1eSA=";
=======
    hash = "sha256-GF+b0rDa9RBnLsT/ZFjSH/GIXG+Hmwew5UfXhK52AGg=";
  };

  vendorHash = "sha256-teGcQX4QbH2RnnIE46VIiYce1TzIwSX41r7FOMsxAvg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = lib.licenses.asl20;
    teams = [ lib.teams.deshaw ];
    mainProgram = "fastly-exporter";
  };
}
