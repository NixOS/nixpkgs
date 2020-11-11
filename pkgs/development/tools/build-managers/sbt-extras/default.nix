{ stdenv, fetchFromGitHub, which, curl, makeWrapper, jdk, writeScript
, common-updater-scripts, cacert, git, nixfmt, nix, jq, coreutils, gnused
, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sbt-extras";
  rev = "a36958f50bf8806c13f7c67ab0f13936e189351b";
  version = "2020-11-08";

  src = fetchFromGitHub {
    owner = "paulp";
    repo = "sbt-extras";
    inherit rev;
    sha256 = "1xp5r7ia8r2nr4g76wp0mnh95d5ha0dblsqvgicq240dgc28360r";
  };

  dontBuild = true;

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    substituteInPlace bin/sbt --replace 'declare java_cmd="java"' 'declare java_cmd="${jdk}/bin/java"'

    install bin/sbt $out/bin

    wrapProgram $out/bin/sbt --prefix PATH : ${
      stdenv.lib.makeBinPath [ which curl ]
    }
  '';

  passthru = {
    tests = { inherit (nixosTests) sbt-extras; };

    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -xo errexit
      PATH=${
        stdenv.lib.makeBinPath [
          common-updater-scripts
          curl
          cacert
          git
          nixfmt
          nix
          jq
          coreutils
          gnused
        ]
      }

      oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
      latestSha="$(curl -L -s https://api.github.com/repos/paulp/sbt-extras/commits\?sha\=master\&since\=$oldVersion | jq -r '.[0].sha')"

      if [ ! "null" = "$latestSha" ]; then
        nixpkgs="$(git rev-parse --show-toplevel)"
        default_nix="$nixpkgs/pkgs/development/tools/build-managers/sbt-extras/default.nix"
        latestDate="$(curl -L -s https://api.github.com/repos/paulp/sbt-extras/commits/$latestSha | jq '.commit.committer.date' | sed 's|"\(.*\)T.*|\1|g')"
        update-source-version ${pname} "$latestSha" --version-key=rev
        update-source-version ${pname} "$latestDate" --ignore-same-hash
        nixfmt "$default_nix"
      else
        echo "${pname} is already up-to-date"
      fi
    '';
  };

  meta = {
    description =
      "A more featureful runner for sbt, the simple/scala/standard build tool";
    homepage = "https://github.com/paulp/sbt-extras";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ nequissimus puffnfresh ];
    platforms = stdenv.lib.platforms.unix;
  };
}
