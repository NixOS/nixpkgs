{ lib
, fetchFromGitHub
, buildPythonPackage
, nassl
, sslyze
, requests
, cryptography
}:
let
  nasslTlsprofiler = nassl.overrideAttrs (
    oldAttrs: rec {
      version = "2.2.0";

      src = fetchFromGitHub {
        owner = "fabian-hk";
        repo = "nassl";
        rev = "7321a149b98175ca20af41561eb04bcb3b7cba41";
        sha256 = "124sx3b0a6bq1w0w5vx4prczmck8n46knxz19ma7acnw5mrdbnx4";
      };

      patches = [
        # Apply upstream patch to update expired cert chain
        ./nassl-0001-Fix-test.patch
      ];
    }
  );
  sslyzeTlsprofiler = (sslyze.override { nassl = nasslTlsprofiler; }).overrideAttrs (
    oldAttrs: rec {
      version = "2.1.4";

      src = fetchFromGitHub {
        owner = "fabian-hk";
        repo = "sslyze";
        rev = "0594f493b3580cb6e639b78de509d4f785ae8c50";
        sha256 = "1y0liz36c1wprxk8sik7n8ysydwklclqk6vp81m7chj9p2n2sh4d";
      };

      # Virtually all tests are online
      doInstallCheck = false;
    }
  );
in
buildPythonPackage rec {
  pname = "tlsprofiler";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "danielfett";
    repo = pname;
    rev = "c4a9cdcf951343ef6cf670df9351c197c6aaab80";
    sha256 = "1ng9ba1w6x9x86cngxx9p4dfjzkf3nn0w4ibn1kmwnf2rgdl6clw";
  };

  patches = [ ./tlsprofiler-setup-requirements.patch ];

  # Tests require Docker to set up web servers which serve a specific profile
  doCheck = false;

  propagatedBuildInputs = [ requests cryptography nasslTlsprofiler sslyzeTlsprofiler ];

  # Also make `run.py` available as `tlsprofiler` application
  postInstall = ''
    sed -i '1s|^|#!/usr/bin/env python3\n|' run.py
    install -D -m755 run.py $out/bin/tlsprofiler
  '';

  meta = with lib; {
    homepage = "https://tlsprofiler.danielfett.de";
    description = "Compare the configuration of a TLS server to the Mozilla TLS configuration recommendations";
    platforms = with platforms; linux ++ darwin;
    license = licenses.agpl3;
    maintainers = with maintainers; [ veehaitch ];
  };
}
