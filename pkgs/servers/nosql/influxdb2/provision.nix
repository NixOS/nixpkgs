{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "influxdb2-provision";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "influxdb2-provision";
    rev = "v${version}";
    hash = "sha256-kgpUtXmwy9buupNzQj/6AIeN8XG2x0XjIckK3WIFC+I=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    python3Packages.python
    python3Packages.influxdb-client
  ];

  installPhase = ''
    install -Dm0555 influxdb2-provision.py $out/bin/influxdb2-provision
    wrapProgram $out/bin/influxdb2-provision --prefix PYTHONPATH : "$PYTHONPATH"
  '';

<<<<<<< HEAD
  meta = {
    description = "Small utility to help provisioning influxdb2";
    homepage = "https://github.com/oddlama/influxdb2-provision";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oddlama ];
=======
  meta = with lib; {
    description = "Small utility to help provisioning influxdb2";
    homepage = "https://github.com/oddlama/influxdb2-provision";
    license = licenses.mit;
    maintainers = with maintainers; [ oddlama ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "influxdb2-provision";
  };
}
