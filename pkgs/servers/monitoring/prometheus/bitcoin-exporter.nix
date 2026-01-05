{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "bitcoin-prometheus-exporter";
  version = "0.9.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "jvstein";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-08QG/5Kj++rjWz7OciqKSJUk00lSJCbfB5XwwP+h4so=";
  };

  # Copying bitcoind-monitor.py is enough.
  # The makefile builds docker containers.
  dontBuild = true;

  propagatedBuildInputs = with python3Packages; [
    prometheus-client
    python-bitcoinlib
    riprova
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bitcoind-monitor.py $out/bin/

    mkdir -p $out/share/${pname}
    cp -r dashboard README.md $out/share/${pname}/
  '';

  meta = {
    description = "Prometheus exporter for Bitcoin Core nodes";
    mainProgram = "bitcoind-monitor.py";
    homepage = "https://github.com/jvstein/bitcoin-prometheus-exporter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mmilata ];
    platforms = lib.platforms.all;
  };
}
