{ lib
, callPackage
, crystal
, fetchFromGitea
, librsvg
, pkg-config
, libxml2
, openssl
, shards
, sqlite
, nixosTests

  # All versions, revisions, and checksums are stored in ./versions.json.
  # The update process is the following:
  #   * pick the latest tag
  #   * update .invidious.version, .invidious.date, .invidious.commit and .invidious.hash
  #   * prefetch the videojs dependencies with scripts/fetch-player-dependencies.cr
  #     and update .videojs.hash (they are normally fetched during build
  #     but nix's sandboxing does not allow that)
  #   * if shard.lock changed
  #     * recreate shards.nix by running crystal2nix
, versions ? lib.importJSON ./versions.json
}:
let
  # normally video.js is downloaded at build time
  videojs = callPackage ./videojs.nix { inherit versions; };
in
crystal.buildCrystalPackage rec {
  pname = "invidious";
  inherit (versions.invidious) version;

  src = fetchFromGitea {
    domain = "gitea.invidious.io";
    owner = "iv-org";
    repo = "invidious";
    fetchSubmodules = true;
    rev = versions.invidious.rev or "v${version}";
    inherit (versions.invidious) hash;
  };

  postPatch =
    let
      # Replacing by the value (templates) of the variables ensures that building
      # fails if upstream changes the way the metadata is formatted.
      branchTemplate = ''{{ "#{`git branch | sed -n '/* /s///p'`.strip}" }}'';
      commitTemplate = ''{{ "#{`git rev-list HEAD --max-count=1 --abbrev-commit`.strip}" }}'';
      versionTemplate = ''{{ "#{`git log -1 --format=%ci | awk '{print $1}' | sed s/-/./g`.strip}" }}'';
      # This always uses the latest commit which invalidates the cache even if
      # the assets were not changed
      assetCommitTemplate = ''{{ "#{`git rev-list HEAD --max-count=1 --abbrev-commit -- assets`.strip}" }}'';

      inherit (versions.invidious) commit date;
    in
    ''
      for d in ${videojs}/*; do ln -s "$d" assets/videojs; done

      # Use the version metadata from the derivation instead of using git at
      # build-time
      substituteInPlace src/invidious.cr \
          --replace-fail ${lib.escapeShellArg branchTemplate} '"master"' \
          --replace-fail ${lib.escapeShellArg commitTemplate} '"${commit}"' \
          --replace-fail ${lib.escapeShellArg versionTemplate} '"${date}"' \
          --replace-fail ${lib.escapeShellArg assetCommitTemplate} '"${commit}"'

      # Patch the assets and locales paths to be absolute
      substituteInPlace src/invidious.cr \
          --replace-fail 'public_folder "assets"' 'public_folder "${placeholder "out"}/share/invidious/assets"'
      substituteInPlace src/invidious/helpers/i18n.cr \
          --replace-fail 'File.read("locales/' 'File.read("${placeholder "out"}/share/invidious/locales/'

      # Reference sql initialisation/migration scripts by absolute path
      substituteInPlace src/invidious/database/base.cr \
            --replace-fail 'config/sql' '${placeholder "out"}/share/invidious/config/sql'

      substituteInPlace src/invidious/user/captcha.cr \
          --replace-fail 'Process.run(%(rsvg-convert' 'Process.run(%(${lib.getBin librsvg}/bin/rsvg-convert'
    '';

  nativeBuildInputs = [ pkg-config shards ];
  buildInputs = [ libxml2 openssl sqlite ];

  format = "crystal";
  shardsFile = ./shards.nix;
  crystalBinaries.invidious = {
    src = "src/invidious.cr";
    options = [
      "--release"
      "--progress"
      "--verbose"
      "--no-debug"
      "-Dskip_videojs_download"
    ];
  };

  postInstall = ''
    mkdir -p $out/share/invidious/config

    # Copy static parts
    cp -r assets locales $out/share/invidious
    cp -r config/sql $out/share/invidious/config
  '';

  # Invidious tries to open and validate config/config.yml, even when
  # running --help. This specifies a minimal configuration in an
  # environment variable. Even though the database and hmac_key are
  # bogus, --help still works.
  installCheckPhase = ''
    export INVIDIOUS_CONFIG="$(cat <<EOF
    database_url: sqlite3:///dev/null
    hmac_key: "this-is-required"
    EOF
    )"
    $out/bin/invidious --help
    $out/bin/invidious --version
  '';

  passthru = {
    tests = { inherit (nixosTests) invidious; };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Open source alternative front-end to YouTube";
    mainProgram = "invidious";
    homepage = "https://invidious.io/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      _999eagle
      GaetanLepage
      sbruder
      pbsds
    ];
  };
}
