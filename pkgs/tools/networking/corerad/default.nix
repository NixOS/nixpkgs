{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "corerad";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "16rwydvqkzi0jlgwpl3d4f8zd35y4lv4h5xa30ybqmwwp1k5ymf0";
  };

  vendorSha256 = "1431fvi9b0id3zhgkxhiampc5avvp998lncyd5l2gn5py3qz6sdl";

  buildFlagsArray = ''
    -ldflags=
    -X github.com/mdlayher/corerad/internal/build.linkTimestamp=1591474872
    -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
