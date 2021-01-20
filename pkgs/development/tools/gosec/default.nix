{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gosec";
  version = "2.5.0";

  subPackages = [ "cmd/gosec" ];

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hwa4sxw9sqzivg80nqsi9g1hz8apnnck73x5dvnn1zbwvycx3g9";
  };

  vendorSha256 = "1lldi56kah689xf8n1hfpk9qy0gbci62xnjs5jrh54kbgka23gvw";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version} -X main.GitTag=${src.rev} -X main.BuildDate=unknown" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

