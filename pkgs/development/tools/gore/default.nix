{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gore";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZNv3sqwOEtxjvyqC9oR8xYwo8sywU2MF8ngBw407/ko=";
  };

  vendorSha256 = "sha256-HrdNWsUVz5G5tG/ZFz2z1Vt4kM12I088/6OIkRFyDl8=";

  doCheck = false;

  meta = with lib; {
    description = "Yet another Go REPL that works nicely";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
