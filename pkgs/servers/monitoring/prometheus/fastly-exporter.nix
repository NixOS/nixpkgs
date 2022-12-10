{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "peterbourgon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oeRf/qjoe8ThzuyIGPOWO+5KTY318Fz3TGp5svXBGQU=";
  };

  vendorSha256 = "sha256-BBfI5SyTgaoXXHxhraH09YVi43v1mD6Ia8oyh+TYqvA=";

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/peterbourgon/fastly-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
