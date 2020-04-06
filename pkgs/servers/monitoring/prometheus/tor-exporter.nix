{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "tor-exporter-${version}";
  version = "0.4";

  # Just a single .py file to use as the application's main entry point.
  format = "other";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "atx";
    repo = "prometheus-tor_exporter";
    sha256 = "1gzf42z0cgdqijbi9cwpjkqzkvnabaxkkfa5ac5h27r3pxx3q4n0";
  };

  propagatedBuildInputs = with python3Packages; [ prometheus_client stem retrying ];

  installPhase = ''
    mkdir -p $out/share/
    cp prometheus-tor-exporter.py $out/share/
  '';

  fixupPhase = ''
    makeWrapper "${python3Packages.python.interpreter}" "$out/bin/prometheus-tor-exporter" \
          --set PYTHONPATH "$PYTHONPATH" \
          --add-flags "$out/share/prometheus-tor-exporter.py"
  '';

  meta = with lib; {
    description = "Prometheus exporter that exposes metrics from a Tor daemon";
    homepage = https://github.com/atx/prometheus-tor_exporter;
    license = licenses.mit;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.unix;
  };
}
