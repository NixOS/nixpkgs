{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gosec";
  version = "2.7.0";

  subPackages = [ "cmd/gosec" ];

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U7+0wXnuIDlATpVRVknwaPxib36+iYvvYUVM6d7Xf6I=";
  };

  vendorSha256 = "sha256-nr1rx6GM+ETcfLreYT081xNzUz2exloogJ+gcwF2u2o=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version} -X main.GitTag=${src.rev} -X main.BuildDate=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

