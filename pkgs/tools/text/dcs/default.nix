{ lib
, buildGoModule
, fetchFromGitHub
, yuicompressor
, zopfli
, stdenv
}:
buildGoModule {
  pname = "dcs";
  version = "unstable-2021-04-07";

  src = fetchFromGitHub {
    owner = "Debian";
    repo = "dcs";
    rev = "da46accc4d55e9bfde1a6852ac5a9e730fcbbb2c";
    sha256 = "N+6BXlKn1YTlh0ZdPNWa0nuJNcQtlUIc9TocM8cbzQk=";
  };

  vendorSha256 = "l2mziuisx0HzuP88rS5M+Wha6lu8P036wJYZlmzjWfs=";

  # Depends on dcs binaries
  doCheck = false;

  nativeBuildInputs = [
    yuicompressor
    zopfli
  ];

  postBuild = ''
    make -C static -j$NIX_BUILD_CORES
  '';

  postInstall = ''
    mkdir -p $out/share/dcs
    cp -r cmd/dcs-web/templates $out/share/dcs
    cp -r static $out/share/dcs
  '';

  meta = with lib; {
    description = "Debian Code Search";
    homepage = "https://github.com/Debian/dcs";
    license = licenses.bsd3;
    maintainers = [ ];
    broken = stdenv.isAarch64
      || stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/dcs.x86_64-darwin
  };
}
