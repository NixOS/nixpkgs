{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "mpd-mpris";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "natsukagami";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QxPkGWpCWiyEbChH9SHeD+SiV8k0c/G7MG/azksP3xU=";
  };

  patches = [
    # Makes Exec= path not absolute, see https://github.com/natsukagami/mpd-mpris/pull/42
    (fetchpatch {
      url = "https://github.com/natsukagami/mpd-mpris/commit/8a5b53b1aa3174c3ccb1db24fb4e39f90012b98f.patch";
      hash = "sha256-LArPq+RRPJOs0je1olqg+pK7nvU7UIlrpGtHv2PhIY4=";
    })
  ];

  vendorHash = "sha256-HCDJrp9WFB1z+FnYpOI5e/AojtdnpN2ZNtgGVaH/v/Q=";

  doCheck = false;

  subPackages = [ "cmd/${pname}" ];

  postInstall = ''
    install -Dm644 mpd-mpris.service $out/lib/systemd/user/mpd-mpris.service
    install -Dm644 mpd-mpris.desktop $out/etc/xdg/autostart/mpd-mpris.desktop
  '';

  meta = with lib; {
    description = "An implementation of the MPRIS protocol for MPD";
    homepage = "https://github.com/natsukagami/mpd-mpris";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
