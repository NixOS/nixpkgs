{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "bitcoin-prometheus-exporter";
  version = "0.7.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "jvstein";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZWr+bBNnRYzqjatOJ4jYGzvTyfheceY2UDvG4Juvo5I=";
  };

  # Copying bitcoind-monitor.py is enough.
  # The makefile builds docker containers.
  dontBuild = true;

  propagatedBuildInputs = with python3Packages; [
    prometheus-client
    bitcoinlib
    riprova
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bitcoind-monitor.py $out/bin/

    mkdir -p $out/share/${pname}
    cp -r dashboard README.md $out/share/${pname}/
  '';

  meta = with lib; {
    description = "Prometheus exporter for Bitcoin Core nodes";
    mainProgram = "bitcoind-monitor.py";
    homepage = "https://github.com/jvstein/bitcoin-prometheus-exporter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmilata ];
    platforms = platforms.all;
  };
}
