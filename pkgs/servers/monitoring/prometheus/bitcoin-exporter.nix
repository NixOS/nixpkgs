{ lib, fetchFromGitHub, fetchpatch, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "bitcoin-prometheus-exporter";
  version = "0.5.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "jvstein";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l0j6dyb0vflh386z3g8srysay5sf47g5rg2f5xrkckv86rjr115";
  };

  patches = [
    # remove after update to new release
    (fetchpatch {
      name = "configurable-listening-address.patch";
      url = "https://patch-diff.githubusercontent.com/raw/jvstein/bitcoin-prometheus-exporter/pull/11.patch";
      sha256 = "0a2l8aqgprc1d5k8yg1gisn6imh9hzg6j0irid3pjvp5i5dcnhyq";
    })
  ];

  propagatedBuildInputs = with python3Packages; [ prometheus-client bitcoinlib riprova ];

  installPhase = ''
    mkdir -p $out/bin
    cp bitcoind-monitor.py $out/bin/

    mkdir -p $out/share/${pname}
    cp -r dashboard README.md $out/share/${pname}/
  '';

  meta = with lib; {
    description = "Prometheus exporter for Bitcoin Core nodes";
    homepage = "https://github.com/jvstein/bitcoin-prometheus-exporter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmilata ];
    platforms = platforms.all;
  };
}
