{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "iceportal";
  version = "2021-11-15";

  src = fetchFromGitHub {
    owner = "craftamap";
    repo = "${pname}-api";
    rev = "f73278c28cb5de53e6ab5ec0a99c0e606582cc3d";
    sha256 = "0lg5iaj9pb3am7i17zfl33pv9bkwbfxaz9wc6s9m1z6mxg4s0a1y";
  };

  vendorSha256 = "1in0gf4adhlwxphqm56dyv4dn81m7v9in26nd26zjf5ggfq8s3sb";

  meta = with lib; {
    description = "client to interact with the REST API of iceportal.de";
    longDescription = ''
      iceportal-api is a Golang client implementation to interact with the REST
      API of iceportal.de when connected to the WiFi-Network offered in German
      ICE Trains.
    '';
    homepage = "https://github.com/craftamap/iceportal-api";
    maintainers = [ maintainers.matthiasbeyer ];
    license = licenses.mit;
  };
}

