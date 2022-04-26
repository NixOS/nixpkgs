{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "adguard-exporter";
  rev = "23838bf07e3b116f267677e3eb891e5425f99af8";

  src = fetchFromGitHub {
    inherit rev;
    owner = "ebrianne";
    repo = "adguard-exporter";
    sha256 = "sha256:1ld5kwasa90rmczsmh5zdssar5jryvs9iifhxmbdd67j0qav4bl0";
  };

  vendorSha256 = "sha256:15bkw31lna648ynq3h0wvd4w60jaci33kr0mp4919rk42ybyb8pw";

  meta = with lib; {
    description = "Adguard exporter based on eko/pihole-exporter ";
    homepage = "https://github.com/ebrianne/adguard-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ jdheyburn ];
  };
}
