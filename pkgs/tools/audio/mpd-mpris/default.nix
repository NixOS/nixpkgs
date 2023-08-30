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

  vendorHash = "sha256-HCDJrp9WFB1z+FnYpOI5e/AojtdnpN2ZNtgGVaH/v/Q=";

  doCheck = false;

  subPackages = [ "cmd/${pname}" ];

  postInstall = ''
    substituteInPlace mpd-mpris.service \
      --replace /usr/bin $out/bin
    mkdir -p $out/lib/systemd/user
    cp mpd-mpris.service $out/lib/systemd/user
  '';

  meta = with lib; {
    description = "An implementation of the MPRIS protocol for MPD";
    homepage = "https://github.com/natsukagami/mpd-mpris";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
