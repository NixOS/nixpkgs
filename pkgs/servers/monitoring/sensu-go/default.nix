{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

let
  generic =
    {
      subPackages,
      pname,
      postInstall ? "",
      mainProgram,
    }:
    buildGoModule rec {
      inherit pname;
      version = "6.13.1";
      shortRev = "591ed6e"; # for internal version info

      src = fetchFromGitHub {
        owner = "sensu";
        repo = "sensu-go";
        rev = "v${version}";
        sha256 = "sha256-VYdm1aNz1IXvDezrJB5yyViIWPl4zf4/xmkw2pm8gyk=";
      };

      inherit subPackages postInstall;

      vendorHash = "sha256-32jz5CI94BZxMDo6Crc05DDvlXxMsldJpWvhfHLS37o=";

      doCheck = false;

      ldflags =
        let
          versionPkg = "github.com/sensu/sensu-go/version";
        in
        [
          "-X ${versionPkg}.Version=${version}"
          "-X ${versionPkg}.BuildSHA=${shortRev}"
        ];

      meta = {
        inherit mainProgram;
        homepage = "https://sensu.io";
        description = "Open source monitoring tool for ephemeral infrastructure & distributed applications";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
          thefloweringash
          teutat3s
        ];
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
    mainProgram = "sensuctl";
  };

  sensu-go-backend = generic {
    pname = "sensu-go-backend";
    subPackages = [ "cmd/sensu-backend" ];
    mainProgram = "sensu-backend";
  };

  sensu-go-agent = generic {
    pname = "sensu-go-agent";
    subPackages = [ "cmd/sensu-agent" ];
    mainProgram = "sensu-agent";
  };
}
