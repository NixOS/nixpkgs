{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "httplab";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "qustavo";
    repo = "httplab";
    rev = "v${version}";
    hash = "sha256-+qcECfQo9Wa4JQ09ujhKjQndmcFn03hTfII636+1ghA=";
  };

  vendorHash = null;

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/qustavo/httplab/commit/80680bebc83f1ed19216f60339c62cd9213d736b.patch";
      hash = "sha256-y4KO3FGwKNAfM+4uR3KDbV90d/4JeBGvWtfirDJrWZk=";
    })
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/qustavo/httplab";
    description = "Interactive WebServer";
    license = licenses.mit;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
