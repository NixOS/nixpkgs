{ lib
, buildGoModule
, fetchFromGitHub
, git
, tree
}:
buildGoModule rec {
  pname = "FerretDB";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WSdscZ1/Dix83RE95Iv61rdaSBWx1GMi6qOIPNus+ZI=";
  };

  vendorSha256 = "sha256-fGmGE08w9w2QnBVdMZ2IKo8Zq3euJGCBVTTHNKYFY3U=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  # We cannot run the `go generate` command since it requires full git history
  # (deepClone and leaveDotGit does not seem to help)
  preBuild = ''
    echo ${version} > internal/util/version/gen/version.txt
  '';

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://github.com/FerretDB/FerretDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
