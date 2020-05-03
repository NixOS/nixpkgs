{ buildGoPackage
, lib
, fetchFromGitHub
, fetchpatch
}:

buildGoPackage rec {
  pname = "asmfmt";
  version = "1.2.1";

  goPackagePath = "github.com/klauspost/asmfmt";

  src = fetchFromGitHub {
    owner = "klauspost";
    repo = "asmfmt";
    rev = "v${version}";
    sha256 = "0qwxb4yx12yl817vgbhs7acaj98lgk27dh50mb8sm9ccw1f43h9i";
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
