{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "delve";
  version = "1.6.1";

  goPackagePath = "github.com/go-delve/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "sha256-bTVCasemE8Vyjcs8wZBiiXEsW3UBndjpPQ5bi+4vQkw=";
  };

  meta = with lib; {
    description = "debugger for the Go programming language";
    homepage = "https://github.com/derekparker/delve";
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
