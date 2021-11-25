{ lib, stdenv, buildGoModule, fetchFromGitHub, pkg-config, btrfs-progs, gpgme, lvm2 }:

buildGoModule rec {
  pname = "dive";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1pmw8pUlek5FlI1oAuvLSqDow7hw5rw86DRDZ7pFAmA=";
  };

  vendorSha256 = "sha256-0gJ3dAPoilh3IWkuesy8geNsuI1T0DN64XvInc9LvlM=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = "https://github.com/wagoodman/dive";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie SuperSandro2000 ];
  };
}
