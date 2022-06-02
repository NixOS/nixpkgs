{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "asmfmt";
  version = "1.3.2";

  goPackagePath = "github.com/klauspost/asmfmt";

  src = fetchFromGitHub {
    owner = "klauspost";
    repo = "asmfmt";
    rev = "v${version}";
    sha256 = "sha256-YxIVqPGsqxvOY0Qz4Jw5FuO9IbplCICjChosnHrSCgc=";
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
