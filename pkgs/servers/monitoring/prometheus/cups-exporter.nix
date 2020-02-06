{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-cups-exporter-unstable";
  version = "2019-03-17";

  format = "other";

  src = fetchFromGitHub {
    owner = "ThoreKr";
    repo = "cups_exporter";
    rev = "8fd1c2517e9878b7b7c73a450e5e546f437954a9";
    sha256 = "1cwk2gbw2svqjlzgwv5wqzhq7fxwrwsrr0kkbnqn4mfb0kq6pa8m";
  };

  propagatedBuildInputs = with python3Packages; [ prometheus_client pycups ];

  installPhase = ''
    mkdir -p $out/share/
    cp cups_exporter.py $out/share/
  '';

  fixupPhase = ''
    makeWrapper "${python3Packages.python.interpreter}" "$out/bin/prometheus-cups-exporter" \
          --set PYTHONPATH "$PYTHONPATH" \
          --add-flags "$out/share/cups_exporter.py"
  '';

  meta = with lib; {
    description = "A simple prometheus exporter for cups implemented in python";
    homepage = "https://github.com/ThoreKr/cups_exporter";
    license = licenses.unfree;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.all;
  };
}
