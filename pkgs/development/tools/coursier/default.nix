{ lib, stdenv, fetchurl, makeWrapper, jre, writeScript, common-updater-scripts
, coreutils, git, gnused, nix, zlib }:

let
  libPath = lib.makeLibraryPath [
    zlib # libz.so.1
  ];
in
stdenv.mkDerivation rec {
  pname = "coursier";
  version = "2.1.8";

  src = fetchurl {
    url = "https://github.com/coursier/coursier/releases/download/v${version}/coursier";
    hash = "sha256-fnd2/4ea411c/f3p/BzIHekoRYVznobJbBY4NGb1NwI=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm555 $src $out/bin/cs
    patchShebangs $out/bin/cs
    wrapProgram $out/bin/cs \
      --prefix PATH ":" ${lib.makeBinPath [ jre ]} \
      --prefix LD_LIBRARY_PATH ":" ${libPath}

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!${stdenv.shell}
    set -o errexit
    PATH=${lib.makeBinPath [ common-updater-scripts coreutils git gnused nix ]}
    oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
    latestTag="$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags https://github.com/coursier/coursier.git 'v*.*.*' | tail --lines=1 | cut --delimiter='/' --fields=3 | sed 's|^v||g')"
    if [ "$oldVersion" != "$latestTag" ]; then
      nixpkgs="$(git rev-parse --show-toplevel)"
      default_nix="$nixpkgs/pkgs/development/tools/coursier/default.nix"
      update-source-version ${pname} "$latestTag" --version-key=version --print-changes
    else
      echo "${pname} is already up-to-date"
    fi
  '';

  meta = with lib; {
    homepage = "https://get-coursier.io/";
    description = "Scala library to fetch dependencies from Maven / Ivy repositories";
    license = licenses.asl20;
    maintainers = with maintainers; [ adelbertc nequissimus ];
    platforms = platforms.all;
  };
}
