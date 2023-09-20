{ buildGoModule, fetchFromGitHub, lib, lm_sensors }:

buildGoModule rec {
  pname = "fan2go";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "markusressel";
    repo = pname;
    rev = version;
    sha256 = "w2Qwu3ZmBkoA86xa7V6pnIBAbfG9mtkAHePkQjefRW8=";
  };

  vendorSha256 = "6OEdl7ie0dTjXrG//Fvcg4ZyTW/mhrUievDljY2zi/4=";

  postConfigure = ''
    substituteInPlace vendor/github.com/md14454/gosensors/gosensors.go \
      --replace '"/etc/sensors3.conf"' '"${lm_sensors}/etc/sensors3.conf"'
  '';

  CGO_CFLAGS = "-I ${lm_sensors}/include";
  CGO_LDFLAGS = "-L ${lm_sensors}/lib";

  meta = with lib; {
    description = "A simple daemon providing dynamic fan speed control based on temperature sensors";
    homepage = "https://github.com/markusressel/fan2go";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mtoohey ];
    platforms = platforms.linux;
  };
}
