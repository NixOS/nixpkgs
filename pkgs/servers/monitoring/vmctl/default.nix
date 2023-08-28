{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "vmctl";
  version = "1.93.1";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaMetrics";
    rev = "v${version}";
    sha256 = "sha256-52OY4sZ2UI+p6+QYkRW8Ov9SbLPKmvgvgV7rhfo0tAY=";
  };

  ldflags = ["-s" "-w" "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${version}"];

  vendorHash = null;

  subPackages = ["app/vmctl"];

  meta = with lib; {
    homepage = "https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmctl";
    description = "VictoriaMetrics command-line tool";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [nullx76 viktornordling];
  };
}
