{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "uroboros";
  version = "20210304-${lib.strings.substring 0 7 rev}";
  rev = "9bed95bb4cc44cfd043e8ac192e788df379c7a44";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = pname;
    inherit rev;
    sha256 = "1a1bc2za2ppb7j7ibhykgxwivwmx7yq0593255jd55gl60r0l7i4";
  };

  vendorSha256 = "1ml3x00zzkwj1f76a4wk2y8z4bxjhadf2p1li96qjpnc8fgfd50l";

  meta = with lib; {
    description = "Tool for monitoring and profiling single processes";
    homepage = "https://github.com/evilsocket/uroboros";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
