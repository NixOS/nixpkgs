{
  lib,
  buildGoModule,
  fetchFromSourcehut,
}:

buildGoModule rec {
  pname = "qcal";
  version = "0.9.2";
  src = fetchFromSourcehut {
    owner = "~psic4t";
    repo = "qcal";
    rev = version;
    hash = "sha256-azUN4oYbD0fBZav4ogh/mELV9+IW6aAV7Oom8Wq6sYI=";
  };
  vendorHash = "sha256-W9g2JzShvm2hJ+fcdwsoD3B6iUU55ufN6FTTl6qK6Oo=";

  # Replace "config-sample.json" in error message with the absolute path
  # to that config file in the nix store
  preBuild = ''
    substituteInPlace helpers.go \
      --replace-fail " config-sample.json " " $out/share/qcal/config-sample.json "
  '';

  postInstall = ''
    mkdir -p $out/share/qcal
    cp config-sample.json $out/share/qcal/
  '';

  meta = with lib; {
    description = "CLI calendar application for CalDAV servers written in Go";
    homepage = "https://git.sr.ht/~psic4t/qcal";
    changelog = "https://git.sr.ht/~psic4t/qcal/refs/${version}";
    license = licenses.gpl3;
    mainProgram = "qcal";
    maintainers = with maintainers; [ antonmosich ];
  };
}
