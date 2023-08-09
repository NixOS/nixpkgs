{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asmfmt";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "klauspost";
    repo = "asmfmt";
    rev = "v${version}";
    sha256 = "sha256-YxIVqPGsqxvOY0Qz4Jw5FuO9IbplCICjChosnHrSCgc=";
  };

  vendorSha256 = null;

  # This package comes with its own version of goimports, gofmt and goreturns
  # but these binaries are outdated and are offered by other packages.
  subPackages = [ "cmd/asmfmt" ];

  ldflags = [ "-s" "-w" ];

  # There are no tests.
  doCheck = false;

  meta = with lib; {
    description = "Go assembler formatter";
    longDescription = ''
      This will format your assembler code in a similar way that gofmt formats
      your Go code.
    '';
    homepage = "https://github.com/klauspost/asmfmt";
    changelog = "https://github.com/klauspost/asmfmt/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
