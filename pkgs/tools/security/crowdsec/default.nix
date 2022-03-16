{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, jq, fetchpatch }:

buildGoModule rec {
  pname = "crowdsec";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "crowdsecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EbwvNRzd28pVUk/obOqyIAcaTEafczJ62TTJAOw5QEA=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00_00:00:00
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%d_%H:%M:%S" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/crowdsecurity/crowdsec/pull/1302/commits/07f2b64f63ed339bc7f7664192452060929ccd2b.patch";
      sha256 = "sha256-bTfJt3ZfHUsLRPGF6mHnaEsGNoMCvWS0sA4Ylw/o5ao=";
    })
  ];

  vendorSha256 = "sha256-fZj+gViuyu6oapj18aGQxWsrLeTlPo+SZdbDPrPSpFA=";

  nativeBuildInputs = [ installShellFiles jq ];

  subPackages = [ "cmd/crowdsec-cli" "cmd/crowdsec" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crowdsecurity/crowdsec/pkg/cwversion.Version=v${version}"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/crowdsecurity/crowdsec/pkg/cwversion.Tag=$(cat COMMIT)"
    ldflags+=" -X github.com/crowdsecurity/crowdsec/pkg/cwversion.BuildDate=$(cat SOURCE_DATE_EPOCH)"
    ldflags+=" -X github.com/crowdsecurity/crowdsec/pkg/cwversion.Codename=$(jq -r .CodeName < RELEASE.json)"
  '';

  postBuild = ''
    mv $GOPATH/bin/{crowdsec-cli,cscli}
  '';

  # many failing tests due to expecting files such as /etc/shadow and services such as docker
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/crowdsec
    cp -r ./config $out/share/crowdsec/

    # --config since it fails if the file doesn't exist or look like real config
    # luckily there's some config in ./config
    installShellCompletion --cmd cscli \
      --bash <($out/bin/cscli completion --config ./config/config.yaml bash) \
      --zsh <($out/bin/cscli completion --config ./config/config.yaml zsh)
  '';

  meta = with lib; {
    homepage = "https://crowdsec.net/";
    changelog = "https://github.com/crowdsecurity/crowdsec/releases/tag/v${version}";
    description = "CrowdSec is a free, open-source and collaborative IPS";
    longDescription = ''
      CrowdSec is a free, modern & collaborative behavior detection engine,
      coupled with a global IP reputation network. It stacks on fail2ban's
      philosophy but is IPV6 compatible and 60x faster (Go vs Python), uses Grok
      patterns to parse logs and YAML scenario to identify behaviors. CrowdSec
      is engineered for modern Cloud/Containers/VM based infrastructures (by
      decoupling detection and remediation). Once detected you can remedy
      threats with various bouncers (firewall block, nginx http 403, Captchas,
      etc.) while the aggressive IP can be sent to CrowdSec for curation before
      being shared among all users to further improve everyone's security.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
  };
}
