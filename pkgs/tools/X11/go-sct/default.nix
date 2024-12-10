{
  lib,
  buildGoModule,
  fetchFromGitHub,
  xorg,
  wayland,
}:

buildGoModule rec {
  pname = "go-sct";
  version = "unstable-2022-01-32";

  src = fetchFromGitHub {
    owner = "d4l3k";
    repo = "go-sct";
    rev = "4ae88a6bf50e0b917541ddbcec1ff10ab77a0b15";
    hash = "sha256-/0ilM1g3CNaseqV9i+cKWyzxvWnj+TFqazt+aYDtNVs=";
  };

  postPatch = ''
    # Disable tests require network access
    rm -f geoip/geoip_test.go
  '';

  vendorHash = "sha256-Rx5/oORink2QtRcD+JqbyFroWYhuYmuYDzZ391R4Jsw=";

  buildInputs = [
    xorg.libX11
    xorg.libXrandr
    wayland.dev
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Color temperature setting library and CLI that operates in a similar way to f.lux and Redshift";
    homepage = "https://github.com/d4l3k/go-sct";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "sct";
  };
}
