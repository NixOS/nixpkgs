{ lib, stdenv, fetchurl, makeWrapper, jre, writeScript, common-updater-scripts
, coreutils, git, gnused, nix, nixfmt }:

let
  version = "2.1.0-M5";

  zshCompletion = fetchurl {
    url =
      "https://raw.githubusercontent.com/coursier/coursier/v${version}/modules/cli/src/main/resources/completions/zsh";
    sha256 = "0afxzrk9w1qinfsz55jjrxydw0fcv6p722g1q955dl7f6xbab1jh";
  };

  repo = "git@github.com:coursier/coursier.git";
in stdenv.mkDerivation rec {
  inherit version;

  pname = "coursier";

  src = fetchurl {
    url =
      "https://github.com/coursier/coursier/releases/download/v${version}/coursier";
    sha256 = "sha256-mp341H7bvf3Lwt66GKk3afoCtXuBnD97dYrZNx/jkYI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    install -Dm555 $src $out/bin/cs
    patchShebangs $out/bin/cs
    wrapProgram $out/bin/cs --prefix PATH ":" ${jre}/bin

    # copy zsh completion
    install -Dm755 ${zshCompletion} $out/share/zsh/site-functions/_cs
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!${stdenv.shell}
    set -o errexit
    PATH=${
      lib.makeBinPath [ common-updater-scripts coreutils git gnused nix nixfmt ]
    }
    oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
    latestTag="$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags ${repo} 'v*.*.*' | tail --lines=1 | cut --delimiter='/' --fields=3 | sed 's|^v||g')"
    if [ "$oldVersion" != "$latestTag" ]; then
      nixpkgs="$(git rev-parse --show-toplevel)"
      default_nix="$nixpkgs/pkgs/development/tools/coursier/default.nix"
      update-source-version ${pname} "$latestTag" --version-key=version --print-changes
      url="${builtins.head zshCompletion.urls}"
      completion_url=$(echo $url | sed "s|$oldVersion|$latestTag|g")
      completion_sha256="$(nix-prefetch-url --type sha256 $completion_url)"
      sed -i "s|${zshCompletion.outputHash}|$completion_sha256|g" "$default_nix"
      nixfmt "$default_nix"
    else
      echo "${pname} is already up-to-date"
    fi
  '';

  meta = with lib; {
    homepage = "https://get-coursier.io/";
    description =
      "A Scala library to fetch dependencies from Maven / Ivy repositories";
    license = licenses.asl20;
    maintainers = with maintainers; [ adelbertc nequissimus ];
  };
}
