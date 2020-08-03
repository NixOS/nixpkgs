{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gosec";
  version = "2.4.0";

  goPackagePath = "github.com/securego/gosec";

  subPackages = [ "cmd/gosec" ];

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mqijzr3vj4wycykqpjz9xw9fhpbnzz988z2q3nldb5ax0pyrxca";
  };

  vendorSha256 = "063dpq1k5lykp18gshlgg098yvppicv3cz8gjn1mvfhac2rl9yqr";

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version} -X main.GitTag=${src.rev} -X main.BuildDate=unknown" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

