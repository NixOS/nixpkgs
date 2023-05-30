{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = "${version}";
    sha256 = "sha256-XYISwq6xcVKhXUK6j22pQ5eOfuKNH0uXOEK1MUzSq90=";
  };

  vendorSha256 = "sha256-IV0FZb1rjOMLf+vkzz/ZxUBMFD8VRDS51Wdud/yz32E=";

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ netali ];
  };
}
