{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mpd-mpris";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "natsukagami";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kzjbv04b2garb99l64wdq8yksnm4pbhkgyzh89j5j3gb9k55zal";
  };

  vendorSha256 = "1ggrqwd3h602rav1dc3amsf4wxsq8mdq4ijkdsg759sqhpzl6rqs";

  doCheck = false;

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
