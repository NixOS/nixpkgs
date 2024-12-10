{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "golines";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D0gI9BA0vgM1DBqwolNTfPsTCWuOGrcu5gAVFEdyVGg=";
  };

  vendorHash = "sha256-jI3/m1UdZMKrS3H9jPhcVAUCjc1G/ejzHi9SCTy24ak=";

  meta = with lib; {
    description = "A golang formatter that fixes long lines";
    homepage = "https://github.com/segmentio/golines";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
  };
}
