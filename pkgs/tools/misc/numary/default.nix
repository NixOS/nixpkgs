{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "numary";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "numary";
    repo = "ledger";
    rev = "v${version}";
    hash = "sha256-ZHiWGKl63Tl0Es9W+ChY9dHsnke8NcoDIOzmlxbzHKI=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" --iso-8601=seconds > $out/DATE
      git -C $out rev-parse HEAD > $out/COMMIT
      rm -rf $out/.git
    '';
  };

  vendorSha256 = "sha256-P4/wq2Sn6xEcIzYUFf6Vus1wrBBGKumTYFRoCEfkvrQ=";

  tags = ["json1" "netgo"];

  ldflags = ["-X github.com/numary/ledger/cmd.Version=${version}"];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/numary/ledger/cmd.Commit=$(cat COMMIT)"
    ldflags+=" -X 'github.com/numary/ledger/cmd.BuildDate=$(cat DATE)'"
  '';

  preInstall = ''
    mv $GOPATH/bin/ledger $GOPATH/bin/numary
  '';

  # tests depend on docker runtime
  doCheck = false;

  meta = with lib; {
    description = "A programmable financial ledger to build money-moving apps";
    homepage = "https://www.formance.com/";
    license = licenses.mit;
  };
}
