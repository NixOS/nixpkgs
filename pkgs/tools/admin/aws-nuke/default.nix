{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aws-nuke";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "rebuy-de";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ULHT2ysAVZHSojIdsbPTuwskwOQVrK8f14r9eq+Effs=";
  };

  vendorSha256 = "sha256-GUCsl5VyptNvStJZgCsJDlllZasX1OhbVkahcQFuiC8=";

  preBuild = ''
    if [ "x$outputHashAlgo" != "x" ]; then
      # Only `go generate` when fetching the go mod vendor code
      go generate ./...
    fi
  '';

  doCheck = false;

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Nuke a whole AWS account and delete all its resources";
    homepage = "https://github.com/rebuy-de/aws-nuke";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc ];
  };
}
