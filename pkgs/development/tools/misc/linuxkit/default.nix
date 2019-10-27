{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname   = "linuxkit";
  version = "0.7";

  goPackagePath = "github.com/linuxkit/linuxkit";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    rev = "v${version}";
    sha256 = "1mnaqzd4r0fdgjhjvbi4p0wwvz69i82b33iizz81wvkr1mkakgl2";
  };

  subPackages = [ "src/cmd/linuxkit" ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X github.com/linuxkit/linuxkit/src/cmd/linuxkit/version.Version=${src.rev}")
  '';

  meta = with lib; {
    description = "A toolkit for building secure, portable and lean operating systems for containers";
    license = licenses.asl20;
    homepage = https://github.com/linuxkit/linuxkit;
    maintainers = [ maintainers.nicknovitski ];
    platforms = platforms.unix;
  };
}
