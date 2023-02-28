{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "govulncheck";
  version = "unstable-2023-02-17";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "vuln";
    rev = "b91abcc5ae3c412965b4c8131c4373040c69e1b7";
    sha256 = "sha256-DYeG7SbjoH7rLD+Q0/5VC85bT2x7YxB4tAj1wmHkI4A=";
  };

  vendorSha256 = "sha256-+luU71QHNs7xxXQOLtd+Ka8+ETv5sA+gv+4g7Ogm5TI=";

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
    rm internal/govulncheck/callstacks_test.go
  '';

  ldflags = [ "-s" "-w" ];

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
    maintainers = with maintainers; [ jk ];
  };
}
