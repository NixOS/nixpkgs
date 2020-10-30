{ lib, buildGoModule, fetchFromGitHub }:
let
  sha256 = "01y4wi6j1frfpd6ndwrxw4sr9rwhj8m96mvp76rnszzwgvlydgd4";
  vendorSha256 = "1is4rvga3anmzqqd1bmdw3014lxrvnm19jrfpyvmdqh7pc7cm4i5";
  version = "0.15.5";
in
buildGoModule {
  pname = "step-ca";
  version = version;

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    rev = "v${version}";
    sha256 = sha256;
  };

  goPackagePath = "github.com/smallstep/certificates";
  vendorSha256 = vendorSha256;

  buildPhase = ''
    runHook preBuild
    CGO_ENABLED=0 go build -v -o bin/step-ca -ldflags='-w -X "main.Version=${version}" -X "main.BuildTime=1969-12-31 00:00 UTC"' github.com/smallstep/certificates/cmd/step-ca
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v bin/* $out/bin
  '';

  meta = with lib; {
    description = "A private certificate authority (X.509 & SSH) & ACME server";
    longDescription = ''
      A private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management,
      so you can use TLS everywhere & SSO for SSH
    '';
    homepage = "https://smallstep.com/certificates/";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
    platforms = with platforms; linux ++ darwin;
  };
}
