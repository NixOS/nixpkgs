{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "paperlike-go";
  version = "unstable-2021-03-22";

  src = fetchFromGitHub {
    owner = "leoluk";
    repo = "paperlike-go";
    rev = "a7d89fd4d4cbcec7be016860e9063676ad4cca0f";
    sha256 = "0ym340520a0j4gvgk4x091lcz1apsv9lnwx0nnha86qvzqcy528l";
  };

  subPackages = [ "cmd/paperlike-cli" ];

  vendorSha256 = "00mn0zfivxp2h77s7gmyyjp8p5a1vysn73wwaalgajymvljxxx1r";

  meta = with lib; {
    description = "paperlike-go is a Linux Go library and CLI utility to control a Dasung Paperlike display via I2C DDC.";
    homepage = "https://github.com/leoluk/paperlike-go";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.adisbladis ];
    platforms = lib.platforms.linux;
  };
}
