{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "crowdsec";
<<<<<<< HEAD
  version = "1.5.2";
=======
  version = "1.4.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "crowdsecurity";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-260+XsRn3Mm/zCSvfEcBQ6j715KV4t1Z0CvXdriDzCs=";
  };

  vendorHash = "sha256-Mto0X/LMwWU10cmC2bjzX4lzp9t+nEgsWRP3JGkl++A=";
=======
    hash = "sha256-+WvpsZjb1pb8WqK0HJYncJUo6wPkKzKvBi/nLKuhSD4=";
  };

  vendorHash = "sha256-FPsoufB9UDgBDIE3yUq4doBse3qgjP19ussYnMAxntk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [
    "cmd/crowdsec"
    "cmd/crowdsec-cli"
  ];

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X github.com/crowdsecurity/go-cs-lib/pkg/version.Version=v${version}"
    "-X github.com/crowdsecurity/go-cs-lib/pkg/version.BuildDate=1970-01-01_00:00:00"
    "-X github.com/crowdsecurity/go-cs-lib/pkg/version.Tag=${src.rev}"
    "-X github.com/crowdsecurity/crowdsec/pkg/cwversion.Codename=alphaga"
    "-X github.com/crowdsecurity/crowdsec/pkg/csconfig.defaultConfigDir=/etc/crowdsec"
    "-X github.com/crowdsecurity/crowdsec/pkg/csconfig.defaultDataDir=/var/lib/crowdsec/data"
=======
    "-X github.com/crowdsecurity/crowdsec/pkg/cwversion.Version=v${version}"
    "-X github.com/crowdsecurity/crowdsec/pkg/cwversion.BuildDate=1970-01-01_00:00:00"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postBuild = "mv $GOPATH/bin/{crowdsec-cli,cscli}";

  postInstall = ''
    mkdir -p $out/share/crowdsec
    cp -r ./config $out/share/crowdsec/

    installShellCompletion --cmd cscli \
      --bash <($out/bin/cscli completion bash) \
      --fish <($out/bin/cscli completion fish) \
      --zsh <($out/bin/cscli completion zsh)
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
    maintainers = with maintainers; [ jk urandom ];
  };
}
