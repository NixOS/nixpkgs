{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "teler";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "teler";
    rev = "v${version}";
    sha256 = "07pfqgms5cj4y6zm984qjmmw1c8j9yjbgrp2spi9vzk96s3k3qn3";
  };

  vendorSha256 = "06szi2jw3nayd7pljjlww2gsllgnfg8scnjmc6qv5xl6gf797kdz";

  # test require internet access
  doCheck = false;

  meta = with lib; {
    description = "Real-time HTTP Intrusion Detection";
    longDescription = ''
      teler is an real-time intrusion detection and threat alert
      based on web log that runs in a terminal with resources that
      we collect and provide by the community.
    '';
    homepage = "https://github.com/kitabisa/teler";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
