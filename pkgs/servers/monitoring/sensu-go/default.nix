{ buildGoModule, fetchFromGitHub, lib }:

let
  generic = { subPackages, pname, postInstall ? "" }:
    buildGoModule rec {
      inherit pname;
      version = "5.18.1";
      shortRev = "1f6d16b"; # for internal version info

      goPackagePath = "github.com/sensu/sensu-go";

      src = fetchFromGitHub {
        owner = "sensu";
        repo = "sensu-go";
        rev = "v${version}";
        sha256 = "1iwlkm7ac7brap45r6ly0blywgq6f28r1nws3yf0ybydv30brfj4";
      };

      inherit subPackages postInstall;

      modSha256 = "02h4cav6ivzs3z0qakwxzf5lfy6hzax5c0i2icp0qymqc2789npw";

      buildFlagsArray = let
        versionPkg = "github.com/sensu/sensu-go/version";
      in ''
        -ldflags=
          -X ${versionPkg}.Version=${version}
          -X ${versionPkg}.BuildSHA=${shortRev}
      '';

      meta = {
        homepage = "https://sensu.io";
        description = "Open source monitoring tool for ephemeral infrastructure & distributed applications";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [ thefloweringash ];
      };
    };
in
{
  sensu-go-cli = generic {
    pname = "sensu-go-cli";
    subPackages = [ "cmd/sensuctl" ];
    postInstall = ''
      mkdir -p \
        "''${!outputBin}/share/bash-completion/completions" \
        "''${!outputBin}/share/zsh/site-functions"

      ''${!outputBin}/bin/sensuctl completion bash > ''${!outputBin}/share/bash-completion/completions/sensuctl

      # https://github.com/sensu/sensu-go/issues/3132
      (
        echo "#compdef sensuctl"
        ''${!outputBin}/bin/sensuctl completion zsh
        echo '_complete sensuctl 2>/dev/null'
      ) > ''${!outputBin}/share/zsh/site-functions/_sensuctl

    '';
  };

  sensu-go-backend = generic {
    pname = "sensu-go-backend";
    subPackages = [ "cmd/sensu-backend" ];
  };

  sensu-go-agent = generic {
    pname = "sensu-go-agent";
    subPackages = [ "cmd/sensu-agent" ];
  };
}
