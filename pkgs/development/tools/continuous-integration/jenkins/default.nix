{ lib, stdenv, fetchurl, common-updater-scripts, coreutils, git, gnused
, makeWrapper, nix, nixfmt, openjdk, writeScript, nixosTests, jq, cacert, curl
}:

stdenv.mkDerivation rec {
  pname = "jenkins";
  version = "2.319.2";

  src = fetchurl {
    url = "http://mirrors.jenkins.io/war-stable/${version}/jenkins.war";
    sha256 = "0lx5fng98l9qci5jqwav8dmcnp7k7glfg0ccwqi0xqk90jqqs302";
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
          nixfmt
        ]
      }

      core_json="$(curl -s --fail --location https://updates.jenkins.io/stable/update-center.actual.json | jq .core)"
      oldVersion=$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion jenkins" | tr -d '"')

      version="$(jq -r .version <<<$core_json)"
      sha256="$(jq -r .sha256 <<<$core_json)"
      hash="$(nix-hash --type sha256 --to-base32 "$sha256")"
      url="$(jq -r .url <<<$core_json)"

      if [ ! "$oldVersion" = "$version" ]; then
        update-source-version jenkins "$version" "$hash" "$url"
        nixpkgs="$(git rev-parse --show-toplevel)"
        default_nix="$nixpkgs/pkgs/development/tools/continuous-integration/jenkins/default.nix"
        nixfmt "$default_nix"
      else
        echo "jenkins is already up-to-date"
      fi
    '';
  };

  meta = with lib; {
    description = "An extendable open source continuous integration server";
    homepage = "https://jenkins-ci.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ coconnor fpletz earldouglas nequissimus ];
  };
}
