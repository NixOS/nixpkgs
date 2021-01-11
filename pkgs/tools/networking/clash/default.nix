{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y0im2xs6pibbfri2k7g9jqbzm90jd9a5lghrzasxmkzjfcimrnf";
  };

  vendorSha256 = "0lljm594xgcv7ylz7qn170r9526k9d1lh77m9f9zcnhdd2qw4rw1";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  meta = with lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
  };
}
