{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cliphist";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kmXR8xzjAphgaC2Yd55VwZIJ4ehxP1LEA24hgyAbM7A=";
  };

  vendorSha256 = "sha256-LZnefa0FjYG39YJrSN9ef6OnXHXgSrlSL4LvRqLxFx4=";

  meta = with lib; {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
  };
}
