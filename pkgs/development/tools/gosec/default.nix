{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gosec";
  version = "2.6.1";

  subPackages = [ "cmd/gosec" ];

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KMXRYudnJab/X6FBG0lnG9hHVmbKwnrN1oqkSn6q3DU=";
  };

  vendorSha256 = "sha256-0yxGEUOame9yfeIErLESWY8kZtt7Q4vD3TU6Wl9Xa54=";

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

