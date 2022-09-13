{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "numary";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "numary";
    repo = "ledger";
    rev = "v${version}";
    hash = "sha256-wMfdCCycVXv6Lg1OVzyNXCDk39OdD9mZvbirPtRQols=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" "+%Y-%m-%d %H:%M UTC" > $out/DATE
      git -C $out rev-parse HEAD > $out/COMMIT
      rm -rf $out/.git
    '';
  };

  vendorSha256 = "sha256-P4/wq2Sn6xEcIzYUFf6Vus1wrBBGKumTYFRoCEfkvrQ=";

  ldflags = ["-X github.com/numary/ledger/cmd.Version=${version}"];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/numary/ledger/cmd.Commit=$(cat COMMIT)"
    ldflags+=" -X 'github.com/numary/ledger/cmd.BuildDate=$(cat DATE)'"
  '';

  tags = ["json1" "netgo"];

  # tests depend on docker runtime
  doCheck = false;

  meta = with lib; {
    description = "A programmable financial ledger to build money-moving apps";
    homepage = "https://www.formance.com/";
    license = licenses.mit;
  };
}
