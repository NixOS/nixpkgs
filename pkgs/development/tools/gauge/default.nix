{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-BJyc8umtJUsZgj4jdoYf6PSaDg41mnrZNd6rAdewWro=";
  };

  vendorHash = "sha256-K0LoAJzYzQorKp3o1oH5qruMBbJiCQrduBgoZ0naaLc=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}
