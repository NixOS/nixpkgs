{ lib, buildGoModule, fetchFromGitHub, net-snmp, nixosTests }:

buildGoModule rec {
  pname = "snmp_exporter";
<<<<<<< HEAD
  version = "0.22.0";
=======
  version = "0.21.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-HncffOX0/z8XIEXTOkt6bcnAfY7xwgNBGhUwC3FIJjo=";
  };

  vendorHash = "sha256-n0LPKmGPxLZgvzdpyuE67WOJv7MKN28m7PtQpWYdtMk=";
=======
    sha256 = "sha256-ko2PApbz8kL0n6IEsRKLwMq9WmAdvfwI6o7ZH/BTd6c=";
  };

  vendorSha256 = "sha256-nbJXiZ+vHN/EnvAPTJUKotCE+nwdrXtWHhGfugm+CQQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) snmp; };

  meta = with lib; {
    description = "SNMP Exporter for Prometheus";
    homepage = "https://github.com/prometheus/snmp_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ oida willibutz Frostman ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
