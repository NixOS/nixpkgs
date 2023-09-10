{ lib
, buildGoModule
, fetchFromSourcehut
}:

buildGoModule rec {
  pname = "qcal";
  version = "0.9.1";
  src = fetchFromSourcehut {
    owner = "~psic4t";
    repo = "qcal";
    rev = version;
    hash = "sha256-Rj806cKCFxWB8X4EiKvyZ5/xACw+VVbo9hv8AJiB0S4=";
  };
  vendorHash = "sha256-ntpSj3Ze7n1sMIMojaESi4tQtx+mrA0aiv3+MQetjZI=";

  # Replace "config-sample.json" in error message with the absolute path
  # to that config file in the nix store
  preBuild = ''
    substituteInPlace helpers.go \
      --replace " config-sample.json " " $out/share/config-sample.json "
  '';

  postInstall = ''
    mkdir -p $out/share
    cp config-sample.json $out/share/
  '';

  meta = with lib; {
    description = "CLI calendar application for CalDAV servers written in Go";
    homepage = "https://git.sr.ht/~psic4t/qcal";
    license = licenses.gpl3;
    mainProgram = "qcal";
    maintainers = with maintainers; [ antonmosich ];
  };
}
