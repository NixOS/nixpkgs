{ stdenv, lib, go, fetchurl, fetchgit, fetchFromGitHub }:

stdenv.mkDerivation rec {
  rev = "7534f4943d94a318edde90212439e538ed54cdde";
  version = "git-2015-04-26";
  name = "goimports-${version}";

  buildInputs = [ go ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "tools";
    sha256 = "12ybykrn92l7awav0wkx9yqpc5z0pdwwi29qs9mdr2xspx61rb50";
  };

  buildPhase = ''
    export GOPATH=$src
    go build -v -o goimports golang.org/x/tools/cmd/goimports
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv goimports $out/bin
  '';

  meta = with lib; {
    description = "Import management tool for go";
    homepage = https://godoc.org/golang.org/x/tools/cmd/goimports;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jzellner ];
    platforms = platforms.unix;
  };
}
