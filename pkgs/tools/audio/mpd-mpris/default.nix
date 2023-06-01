{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mpd-mpris";
  version = "0.4.0-2";

  src = fetchFromGitHub {
    owner = "natsukagami";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RGuscED0RvA1+5Aj+Kcnk1h/whU4npJ6hPq8GHWwxPU=";
  };

  vendorHash = "sha256-GmdD/4VYp3KeblNGgltFWHdOnK5qsBa2ygIYOBrH+b0=";

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
    platforms = platforms.unix;
  };
}
