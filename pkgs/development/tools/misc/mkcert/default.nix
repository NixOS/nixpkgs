{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mkcert";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w1ji96hbd3anzsz82xjcafsqhgyz7c7n41rsq60yrllwbj5946f";
  };

  modSha256 = "13a3snhcqq3a9lfy9zfr2rx10mf2ymvhmds1bg8n4m7lbwnzm4fg";

  goPackagePath = "github.com/FiloSottile/mkcert";
  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/main.Version=${version}
  '';

  meta = with lib; {
    homepage = https://github.com/FiloSottile/mkcert;
    description = "A simple tool for making locally-trusted development certificates";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
