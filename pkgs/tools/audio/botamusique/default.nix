{ pkgs
, lib
, stdenv
, fetchFromGitHub
, python3Packages
, ffmpeg
, makeWrapper
, nixosTests

# For the update script
, coreutils
, curl
, nix-prefetch-git
, jq
, nodePackages
}:
let
  nodejs = pkgs.nodejs_14;
  nodeEnv = import ../../../development/node-packages/node-env.nix {
    inherit (pkgs) stdenv lib python2 runCommand writeTextFile writeShellScript;
    inherit pkgs nodejs;
    libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
  };
  botamusiqueNodePackages = import ./node-packages.nix {
    inherit (pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
    inherit nodeEnv;
  };

  srcJson = lib.importJSON ./src.json;
  src = fetchFromGitHub {
    owner = "azlux";
    repo = "botamusique";
    inherit (srcJson) rev sha256;
  };

  nodeDependencies = (botamusiqueNodePackages.shell.override (old: {
    src = src + "/web";
  })).nodeDependencies;

  # Python needed to instantiate the html templates
  buildPython = python3Packages.python.withPackages (ps: [ ps.jinja2 ]);
in
stdenv.mkDerivation rec {
  pname = "botamusique";
  version = srcJson.version;

  inherit src;

  patches = [
    # botamusique by default resolves relative state paths by first checking
    # whether it exists in the working directory, then falls back to using the
    # installation directory. With Nix however, the installation directory is
    # not writable, so that won't work. So we change this so that it uses
    # relative paths unconditionally, whether they exist or not.
    ./unconditional-relative-state-paths.patch

    # We can't update the package at runtime with NixOS, so this patch makes
    # the !update command mention that
    ./no-runtime-update.patch
  ];

  postPatch = ''
    # However, the function that's patched above is also used for
    # configuration.default.ini, which is in the installation directory
    # after all. So we need to counter-patch it here so it can find it absolutely
    substituteInPlace mumbleBot.py \
      --replace "configuration.default.ini" "$out/share/botamusique/configuration.default.ini"
  '';

  nativeBuildInputs = [
    makeWrapper
    nodejs
    python3Packages.wrapPython
  ];

  pythonPath = with python3Packages; [
    flask
    magic
    mutagen
    packaging
    pillow
    pymumble
    pyradios
    requests
    yt-dlp
  ];

  buildPhase = ''
    runHook preBuild

    # Generates artifacts in ./static
    (
      cd web
      ln -s ${nodeDependencies}/lib/node_modules ./node_modules
      export PATH="${nodeDependencies}/bin:$PATH"

      npm run build
    )

    # Fills out http templates
    ${buildPython}/bin/python scripts/translate_templates.py --lang-dir lang/ --template-dir templates/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share $out/bin
    cp -r . $out/share/botamusique
    chmod +x $out/share/botamusique/mumbleBot.py
    wrapPythonProgramsIn $out/share/botamusique "$out $pythonPath"

    # Convenience binary and wrap with ffmpeg dependency
    makeWrapper $out/share/botamusique/mumbleBot.py $out/bin/botamusique \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}

    runHook postInstall
  '';

  passthru.updateScript = pkgs.writeShellScript "botamusique-updater" ''
    export PATH=${lib.makeBinPath [ coreutils curl nix-prefetch-git jq nodePackages.node2nix ]}
    set -ex

    OWNER=azlux
    REPO=botamusique
    VERSION=$(curl https://api.github.com/repos/$OWNER/$REPO/releases/latest | jq -r '.tag_name')

    nix-prefetch-git --rev "$VERSION" --url https://github.com/$OWNER/$REPO | \
      jq > ${toString ./src.json } \
        --arg version "$VERSION" \
        '.version |= $version'
    path=$(jq '.path' -r < ${toString ./src.json})

    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' exit

    # botamusique doesn't have a version in its package.json
    # But that's needed for node2nix
    jq < "$path"/web/package.json > "$tmp/package.json" \
      --arg version "$VERSION" \
      '.version |= $version'

    node2nix \
      --input "$tmp"/package.json \
      --lock "$path"/web/package-lock.json \
      --no-copy-node-env \
      --development \
      --composition /dev/null \
      --output ${toString ./node-packages.nix}
  '';

  passthru.tests = {
    inherit (nixosTests) botamusique;
  };

  meta = with lib; {
    description = "Bot to play youtube / soundcloud / radio / local music on Mumble";
    homepage = "https://github.com/azlux/botamusique";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ infinisil ];
  };
}
