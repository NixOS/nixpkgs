{ buildGoModule, fetchFromGitHub, lib }:

let
  generic = { subPackages, pname, postInstall ? "" }:
    buildGoModule rec {
      inherit pname;
      version = "6.1.2";
      shortRev = "3a1ac58"; # for internal version info

      src = fetchFromGitHub {
        owner = "sensu";
        repo = "sensu-go";
        rev = "v${version}";
        sha256 = "1g4vh4ay5m3sl00j8rn4db87kfdyxcmnaf0rxnv4ah2fbj5nrh2n";
      };

      inherit subPackages postInstall;

  vendorSha256 = "12qi94k8fjx0kaq2x977yhan8ynd6j6cbqx1l60gqs2xgkm71k9r";

  doCheck = false;

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
