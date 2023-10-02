{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wesher";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "costela";
    repo = "wesher";
    rev = "v${version}";
    sha256 = "sha256-EIajvcBhS5G9dJzRgXhnD1QKOAhmzngdyCU4L7itT8U=";
  };

  vendorHash = "sha256-BZzhBC4C0OoAxUEDROkggCQF35C9Z4+0/Jk0ZD8Hz1s=";

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Wireguard overlay mesh network manager";
    homepage = "https://github.com/costela/wesher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tylerjl ];
    platforms   = platforms.linux;
  };
}
