{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "govulncheck";
  version = "unstable-2022-09-02";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "vuln";
    rev = "27dd78d2ca392c1738e54efe513a2ecb7bf46000";
    sha256 = "sha256-G35y1V4W1nLZ+QGvIQwER9whBIBDFUVptrHx78orcI0=";
  };

  vendorSha256 = "sha256-9FH9nq5cEyhMxrrvfQAOWZ4aThMsU0HwlI+0W0uVHZ4=";

  subPackages = [ "cmd/govulncheck" ];

  preCheck = ''
    # test all paths
    unset subPackages

    # remove test that calls checks.bash
    # the header check and misspell gets upset at the vendor dir
    rm all_test.go

    # remove tests that generally have "inconsistent vendoring" issues
    # - tries to builds govulncheck again
    rm cmd/govulncheck/main_command_118_test.go
    # - does go builds of example go files
    rm vulncheck/binary_test.go
    # - just have resolution issues
    rm vulncheck/{source,vulncheck}_test.go
  '';

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck";
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
    maintainers = with maintainers; [ jk ];
  };
}
