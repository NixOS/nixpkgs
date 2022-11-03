{ buildGoModule, fetchFromGitHub, lib, lm_sensors }:

buildGoModule rec {
  pname = "fan2go";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "markusressel";
    repo = pname;
    rev = version;
    sha256 = "3pnJaLD+FEQWAAwIiTkcs9VgqO0JwRaK7JLdIygeChY=";
  };

  vendorSha256 = "9EeiYPNTUEFHxTdvVb2JLU6Qi0oazH+n9MB8Dg+RLJ4=";

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
