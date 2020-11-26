{ stdenv, fetchurl, common-updater-scripts, coreutils, git, gnused, nix, nixfmt
, writeScript, nixosTests, jq, cacert, curl }:

stdenv.mkDerivation rec {
  pname = "jenkins";
  version = "2.249.3";

  src = fetchurl {
    url = "http://mirrors.jenkins.io/war-stable/${version}/jenkins.war";
    sha256 = "00lpqkkz7k0m2czz1sg54gb90sljc14i5a2kpikrkiw8aqfz3s4d";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/jenkins.war"
  '';

  passthru = {
    tests = { inherit (nixosTests) jenkins; };

    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        stdenv.lib.makeBinPath [
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

  meta = with stdenv.lib; {
    description = "An extendable open source continuous integration server";
    homepage = "https://jenkins-ci.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ coconnor fpletz earldouglas nequissimus ];
  };
}
