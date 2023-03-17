{ lib, buildGoModule, fetchFromGitHub, pkg-config, glib, libxml2 }:

buildGoModule rec {
  pname = "ua";
  version = "unstable-2021-12-18";

  src = fetchFromGitHub {
    owner = "sloonz";
    repo = "ua";
    rev = "b6d75970bb4f6f340887e1eadad5aa8ce78f30e3";
    sha256 = "sha256-rCp8jyqQfq5eVdvKZz3vKuDfcR+gQOEAfBZx2It/rb0=";
  };

  vendorSha256 = "sha256-0O80uhxSVsV9N7Z/FgaLwcjZqeb4MqSCE1YW5Zd32ns=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libxml2 ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/sloonz/ua";
    license = licenses.isc;
    description = "Universal Aggregator";
    maintainers = with maintainers; [ ttuegel ];
  };
}
