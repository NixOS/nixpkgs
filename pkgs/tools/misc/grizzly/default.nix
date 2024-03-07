{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "grizzly";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-c+QT3NwfnkVzAb1mqNIuNhSJJOnzME4e3ASawdNBFmg=";
  };

  vendorHash = "sha256-EVP2w0mvzzBcrhohM2VmetK8UQu7fauelSa+C+q3n+g=";

  subPackages = [ "cmd/grr" ];

  meta = with lib; {
    description = "A utility for managing Jsonnet dashboards against the Grafana API";
    homepage = "https://grafana.github.io/grizzly/";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = platforms.unix;
    mainProgram = "grr";
  };
}
