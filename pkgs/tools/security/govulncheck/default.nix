{ lib
, buildGoModule
, fetchFromGitHub
, substituteAll
}:

buildGoModule rec {
  pname = "govulncheck";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "vuln";
    rev = "refs/tags/v${version}";
    hash = "sha256-1x2hj4HD3KAo9w1QXh5qsWtcAM0Kly5u/DRd13Mqa5w=";
  };

  patches = [
    # patch in version information
    (substituteAll {
      src = ./version.patch;
      inherit version;
    })
  ];

  vendorHash = "sha256-Jg2Nx63Xak149111jbBP6SgK3hze21Dx5qcDKXCqa48=";

  subPackages = [
    "cmd/govulncheck"
  ];

  # Vendoring breaks tests
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck";
    downloadPage = "https://github.com/golang/vuln";
    description = "The database client and tools for the Go vulnerability database, also known as vuln";
    longDescription = ''
      Govulncheck reports known vulnerabilities that affect Go code. It uses
      static analysis of source code or a binary's symbol table to narrow down
      reports to only those that could affect the application.

      By default, govulncheck makes requests to the Go vulnerability database at
      https://vuln.go.dev. Requests to the vulnerability database contain only
      module paths, not code or other properties of your program. See
      https://vuln.go.dev/privacy.html for more. Set the GOVULNDB environment
      variable to specify a different database, which must implement the
      specification at https://go.dev/security/vuln/database.

      Govulncheck looks for vulnerabilities in Go programs using a specific
      build configuration. For analyzing source code, that configuration is the
      operating system, architecture, and Go version specified by GOOS, GOARCH,
      and the “go” command found on the PATH. For binaries, the build
      configuration is the one used to build the binary. Note that different
      build configurations may have different known vulnerabilities. For
      example, a dependency with a Windows-specific vulnerability will not be
      reported for a Linux build.
    '';
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ jk SuperSandro2000 ];
  };
}
