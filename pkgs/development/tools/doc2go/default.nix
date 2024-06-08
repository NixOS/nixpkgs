{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "doc2go";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "doc2go";
    rev = "v${version}";
    hash = "sha256-b4L20/9jm+bFGdNsHmcwSnzcmr3Il9XoV20284Ba8PU=";
  };
  vendorHash = "sha256-d5ZRMFi7GIfDHsYRNvMnDdfnGhTM1sA0WDYD2aDoEd0=";

  ldflags = [ "-s" "-w" "-X main._version=${version}" ];

  subPackages = [ "." ];
  # integration is it's own module
  excludedPackages = [ "integration" ];

  checkFlags = [
    # needs to fetch additional go modules
    "-skip=TestFinder_ImportedPackage/Modules"
  ];

  preCheck = ''
    # run all tests
    unset subPackages
  '';

  meta = with lib; {
    homepage = "https://github.com/abhinav/doc2go";
    changelog = "https://github.com/abhinav/doc2go/blob/${src.rev}/CHANGELOG.md";
    description = "Your Go project's documentation, to-go";
    mainProgram = "doc2go";
    longDescription = ''
      doc2go is a command line tool that generates static HTML documentation
      from your Go code. It is a self-hosted static alternative to
      https://pkg.go.dev/ and https://godocs.io/.
    '';
    license = with licenses; [
      # general project license
      asl20
      # internal/godoc/synopsis*.go adapted from golang source
      bsd3
    ];
    maintainers = with maintainers; [ jk ];
  };
}
