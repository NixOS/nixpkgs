{ buildGoPackage, fetchFromGitHub, lib }:

let
  generic = { subPackages, pname, postInstall ? "" }:
    buildGoPackage rec {
      inherit pname;
      version = "5.10.0";
      shortRev = "c7551ba"; # for internal version info

      goPackagePath = "github.com/sensu/sensu-go";

      src = fetchFromGitHub {
        owner = "sensu";
        repo = "sensu-go";
        rev = version;
        sha256 = "1hma54mdh150d51rwz5csqbn0h24qk6hydjmib68j7zd7kp92yb5";
      };

      inherit subPackages postInstall;

      buildFlagsArray = let
        versionPkg = "github.com/sensu/sensu-go/version";
      in ''
        -ldflags=
          -X ${versionPkg}.Version=${version}
          -X ${versionPkg}.BuildSHA=${shortRev}
      '';

      meta = {
        homepage = https://sensu.io;
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
      ''${!outputBin}/bin/sensuctl completion zsh > ''${!outputBin}/share/zsh/site-functions/_sensuctl
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
