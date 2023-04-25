{ lib
, buildGoModule
, fetchFromSourcehut
}:

buildGoModule rec {
  pname = "systemd-lock-handler";
  version = "2.4.1";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "systemd-lock-handler";
    rev = "v${version}";
    hash = "sha256-dkOgdDGwinCvv+pO6wqykhG0J/cRtUb7uOSpIFDReoQ=";
  };

  vendorHash = "sha256-dWzojV3tDA5lLdpAQNC9NaADGyvV7dNOS3x8mfgNNtA=";

  meta = with lib; {
    description = "A systemd helper to handle lock events in systemd";
    homepage = "https://git.sr.ht/~whynothugo/systemd-lock-handler";
    license = licenses.isc;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
