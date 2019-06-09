{ buildGoPackage, fetchFromGitHub, lib }:

let
  generic = { subPackages, pname, postInstall ? "" }:
    buildGoPackage rec {
      inherit pname;
      version = "5.9.0";
      shortRev = "078f625"; # for internal version info

      goPackagePath = "github.com/sensu/sensu-go";

      src = fetchFromGitHub {
        owner = "sensu";
        repo = "sensu-go";
        rev = version;
        sha256 = "1rivnq7m4p44zz1fl46j06aakb0yjsjb3mjqyfq4r0235xr01ajw";
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
