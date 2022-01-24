{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-2+tbwFkT3Z2dfYCs1Fd/9IqD39VuTMGHQ43b7gBBktM=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-nKjJjtVHk/RLIHI/5v8tO4RcaLLZhr0A6llYGsB0ifQ=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 SuperSandro2000 zimbatm ];
  };
}
