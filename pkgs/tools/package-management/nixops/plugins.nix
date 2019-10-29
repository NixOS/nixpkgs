{ lib, python2Packages, fetchFromGitHub }: rec {
  buildNixOpsPlugin =
    { pluginName, name ? "nixops-${pluginName}", src, version, ... }@attrs:
    python2Packages.buildPythonPackage (rec {
      inherit name src;
      prePatch = ''
        substituteInPlace setup.py --subst-var-by version ${version}
      '';
      postInstall = ''
        mkdir -p $out/share/nix/nixops-${pluginName}
        cp -av nix/* $out/share/nix/nixops-${pluginName}
      '';
    } // attrs);

  # Core Plugins
  nixops-aws = buildNixOpsPlugin {
    pluginName = "aws";
    src = fetchFromGitHub {
      owner = "nixos";
      repo = "nixops-aws";
      rev = "c61356ff7337a2df7a24fcc28a11091d255a2665";
      sha256 = "2811ecb981261b5639fce4b757733c27a20573cc8a9a714b16d19ca33c90e74d";
    };
    version = "pre1823_c61356f";
    doCheck = false;
    propagatedBuildInputs = with python2Packages; [ boto boto3 ];
    meta.maintainers = with lib.maintainers; [
      aminechikhaoui
      eelco
      rob
      domenkozar
    ];
  };

  nixops-hetzner = buildNixOpsPlugin {
    pluginName = "hetzner";
    src = fetchFromGitHub {
      owner = "nixos";
      repo = "nixops-hetzner";
      rev = "6245ca44f3682e45d6d82cee7d873f76b51ff693";
      sha256 = "d980c41bef38ce398ba32bc388d6405cf861b6de723259f0afd401d57bbff2fa";
    };
    version = "pre1402_6245ca4";
    doCheck = false;
    propagatedBuildInputs = with python2Packages; [ hetzner ];
    meta.maintainers = with lib.maintainers; [
      aminechikhaoui
      eelco
      rob
      domenkozar
    ];
  };

  # Community Plugins
  nixops-libvirtd = buildNixOpsPlugin {
    pluginName = "libvirtd";
    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nixops-libvirtd";
      rev = "1c29f6c716dad9ad58aa863ebc9575422459bf95";
      sha256 = "155131e2f64f51441af60a0550e57d90053d09749b214ce0d0bce7072b794a3c";
    };
    version = "pre730_1c29f6c";
    propagatedBuildInputs = with python2Packages; [ libvirt ];
    meta.maintainers = with lib.maintainers; [ aminechikhaoui ];
  };

  nixops-vbox = buildNixOpsPlugin {
    pluginName = "vbox";
    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nixops-vbox";
      rev = "bff6054ce9e7f5f9aa830617577f1a511a461063";
      sha256 = "b128943107648782eaa1846ee56314062cba2949f01f33a23c81579c515c1448";
    };
    version = "pre896_bff6054";
    meta.maintainers = with lib.maintainers; [ aminechikhaoui ];
  };

  nixops-datadog = buildNixOpsPlugin {
    pluginName = "datadog";
    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nixops-datadog";
      rev = "3637478b8103658dd9404792cafabe50342a9d72";
      sha256 = "e11fc9ae73ea24ffb86c66aced0436e5a50a5be6f9613ad247a207bdb9cad6d5";
    };
    version = "pre714_3637478";
    propagatedBuildInputs = [ python2Packages.datadog ];
    meta.maintainers = with lib.maintainers; [ aminechikhaoui ];
  };
}
