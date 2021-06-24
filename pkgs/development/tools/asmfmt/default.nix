{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "asmfmt";
  version = "1.2.3";

  goPackagePath = "github.com/klauspost/asmfmt";

  src = fetchFromGitHub {
    owner = "klauspost";
    repo = "asmfmt";
    rev = "v${version}";
    sha256 = "0f2cgwxs2b2kpq5348h8hjkcqc40p8ajapzpcy9ia2fsmsn2a2s4";
  };

  goDeps = ./deps.nix;

  # This package comes with its own version of goimports, gofmt and goreturns
  # but these binaries are outdated and are offered by other packages.
  subPackages = [ "cmd/asmfmt" ];

  meta = with lib; {
    description = "Go Assembler Formatter";
    homepage = "https://github.com/klauspost/asmfmt";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
