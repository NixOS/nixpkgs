{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname   = "linuxkit";
  version = "0.8";

  goPackagePath = "github.com/linuxkit/linuxkit";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    rev = "v${version}";
    sha256 = "15jj60k8wz9cahjbdscnwyyfb1k1grjh7yrilb1cj4r8mby4sp2g";
  };

  subPackages = [ "src/cmd/linuxkit" ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X github.com/linuxkit/linuxkit/src/cmd/linuxkit/version.Version=${src.rev}")
  '';

  meta = with lib; {
    description = "A toolkit for building secure, portable and lean operating systems for containers";
    license = licenses.asl20;
    homepage = "https://github.com/linuxkit/linuxkit";
    maintainers = [ maintainers.nicknovitski ];
    platforms = platforms.unix;
  };
}
