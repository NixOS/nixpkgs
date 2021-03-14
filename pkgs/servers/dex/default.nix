{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dex";
  version = "2.27.0";

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n66nm91qcmm00mz8f8x39xqr3y05qxk34fvka53s6xax1gxvxxi";
  };

  vendorSha256 = "1k87q3ic02n2b632y3lmnclac1iaidmsl3f9py61myi5r02p03lp";

  subPackages = [
    "cmd/dex"
  ];

  buildFlagsArray = [
    "-ldflags=-w -s -X github.com/dexidp/dex/version.Version=${src.rev}"
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
