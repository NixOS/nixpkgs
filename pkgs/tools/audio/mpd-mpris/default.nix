{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mpd-mpris";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "natsukagami";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cr5j2z2ynj1hwkjzi5amcg59vmgazsci41v6vpsj119g7psjmzm";
  };

  vendorSha256 = "108yjymp64iqx1b2wqjbkmbm2w199wq46g7hrmqhcziv6f4aqljp";

  subPackages = [ "cmd/${pname}" ];

  postInstall = ''
    substituteInPlace mpd-mpris.service \
      --replace /usr/bin $out/bin
    mkdir -p $out/lib/systemd/user
    cp mpd-mpris.service $out/lib/systemd/user
  '';

  meta = with stdenv.lib; {
    description = "An implementation of the MPRIS protocol for MPD";
    homepage = "https://github.com/natsukagami/mpd-mpris";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
