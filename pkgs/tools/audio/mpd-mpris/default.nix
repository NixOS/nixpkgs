<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "mpd-mpris";
  version = "0.4.1";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mpd-mpris";
  version = "0.4.0-2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "natsukagami";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
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
=======
    sha256 = "sha256-RGuscED0RvA1+5Aj+Kcnk1h/whU4npJ6hPq8GHWwxPU=";
  };

  vendorHash = "sha256-GmdD/4VYp3KeblNGgltFWHdOnK5qsBa2ygIYOBrH+b0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/${pname}" ];

  postInstall = ''
<<<<<<< HEAD
    install -Dm644 mpd-mpris.service $out/lib/systemd/user/mpd-mpris.service
    install -Dm644 mpd-mpris.desktop $out/etc/xdg/autostart/mpd-mpris.desktop
=======
    substituteInPlace mpd-mpris.service \
      --replace /usr/bin $out/bin
    mkdir -p $out/lib/systemd/user
    cp mpd-mpris.service $out/lib/systemd/user
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "An implementation of the MPRIS protocol for MPD";
    homepage = "https://github.com/natsukagami/mpd-mpris";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
