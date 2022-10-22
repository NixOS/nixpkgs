{ lib, buildGoModule, fetchFromGitHub }:
let
  pname = "speedtest_exporter";
  version = "0.3.2";

  src = fetchFromGitHub {
      owner = "nlamirault";
      repo = "speedtest_exporter";
      rev = "7364db62b98ab2736405c7cde960698ab5b688bf";
      sha256 = "WIMDv63sHyZVw3Ct5LFXCIufj7sU2H81n+hT/NiPMeQ=";
    };

in buildGoModule rec {
  inherit pname version src;

  vendorSha256 = "Lm73pZzdNZv7J+vKrtQXxm4HiAuB9lugKT/oanmD0HM=";

  meta = with lib; {
      license = licenses.asl20;
      homepage = "https://github.com/nlamirault/speedtest_exporter";
      description = "Prometheus exporter for Speedtest metrics";
      maintainers = with maintainers; [ jonaenz ];
      platforms = platforms.unix;
  };
}
