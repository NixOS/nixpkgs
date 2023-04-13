{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20230404";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nh59sfOWLk4evuIxa35bWu0J6xSUIzrPv4oQHWSZInA=";
  };

  vendorHash = "sha256-PYdR0vfgOgRheHDvoIC9jCFmfzCSOhxqcPFm+MqirsQ=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}
