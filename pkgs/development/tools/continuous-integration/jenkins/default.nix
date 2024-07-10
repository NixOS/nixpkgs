{ lib, stdenv, fetchurl, common-updater-scripts, coreutils, git, gnused
, makeWrapper, nix, nixfmt-classic, openjdk, writeScript, nixosTests, jq, cacert
, curl }:

stdenv.mkDerivation rec {
  pname = "jenkins";
  version = "2.452.2";

  src = fetchurl {
    url = "https://get.jenkins.io/war-stable/${version}/jenkins.war";
    hash = "sha256-Ng78hDjbmkuiB3KYHUJXz+aDe/DD+4yOmyJT2M5rozk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p "$out/bin" "$out/share" "$out/webapps"

    cp "$src" "$out/webapps/jenkins.war"

    # Create the `jenkins-cli` command.
    ${openjdk}/bin/jar -xf "$src" WEB-INF/lib/cli-${version}.jar \
      && mv WEB-INF/lib/cli-${version}.jar "$out/share/jenkins-cli.jar"

    makeWrapper "${openjdk}/bin/java" "$out/bin/jenkins-cli" \
      --add-flags "-jar $out/share/jenkins-cli.jar"
  '';

  passthru = {
    tests = { inherit (nixosTests) jenkins jenkins-cli; };

    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        lib.makeBinPath [
          cacert
          common-updater-scripts
          coreutils
          curl
          git
          gnused
          jq
          nix
          nixfmt-classic
        ]
      }

      core_json="$(curl -s --fail --location https://updates.jenkins.io/stable/update-center.actual.json | jq .core)"
      oldVersion=$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion jenkins" | tr -d '"')

      version="$(jq -r .version <<<$core_json)"
      sha256="$(jq -r .sha256 <<<$core_json)"
      hash="$(nix hash to-sri --type sha256 "$sha256")"

      if [ ! "$oldVersion" = "$version" ]; then
        update-source-version jenkins "$version" "$hash"
        nixpkgs="$(git rev-parse --show-toplevel)"
        default_nix="$nixpkgs/pkgs/development/tools/continuous-integration/jenkins/default.nix"
        nixfmt "$default_nix"
      else
        echo "jenkins is already up-to-date"
      fi
    '';
  };

  meta = with lib; {
    description = "Extendable open source continuous integration server";
    homepage = "https://jenkins.io/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers;
      [ coconnor earldouglas nequissimus ] ++ teams.helsinki-systems.members;
    changelog = "https://www.jenkins.io/changelog-stable/#v${version}";
    mainProgram = "jenkins-cli";
    platforms = platforms.all;
  };
}
