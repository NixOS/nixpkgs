{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dex";
  version = "2.28.1";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MdrkQ4qclylkan8y845BjLiL+W16iqRuNMmvWsKo+zw=";
  };

  vendorSha256 = "sha256-rAqqvnP72BQY/qbSvqNzxh2ZUlF/rP0MR/+yqJai+KY=";

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w" "-s" "-X github.com/dexidp/dex/version.Version=${src.rev}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r $src/web $out/share/web
  '';

  meta = with lib; {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
