{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, systemd
,
}:
rustPlatform.buildRustPackage rec {
  pname = "espmonitor";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "hWFdim84L2FfG6p9sEf+G5Uq4yhp5kv1ZMdk4sMHa+4=";
  };

  cargoSha256 = "d0tN6NZiAd+RkRy941fIaVEw/moz6tkpL0rN8TZew3g=";

  meta = with lib; {
    description = "Cargo tool for monitoring ESP32/ESP8266 execution";
    homepage = "https://github.com/esp-rs/espmonitor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xanderio ];
  };
}
