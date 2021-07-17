{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "v2ray-exporter";
  version = "0.5.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "wi1dcard";
    repo = "v2ray-exporter";
    sha256 = "1dqiyy3mj1pid97d986yvz93d80kki71fk1afzzpzkbnas2cd4s3";
  };

  vendorSha256 = "048bc48nvh4aw4iv20nk99ggmp0db8yb0rziljg6l6zjjvilwdrp";

  meta = with lib; {
    description = "Prometheus exporter for V2Ray daemon";
    homepage = "https://github.com/wi1dcard/v2ray-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ jqqqqqqqqqq ];
  };
}
