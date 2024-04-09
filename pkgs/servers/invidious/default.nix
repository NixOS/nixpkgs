{ lib, stdenv, crystal, fetchFromGitea, librsvg, pkg-config, libxml2, openssl, shards, sqlite, lsquic, videojs, nixosTests }:
let
  # All versions, revisions, and checksums are stored in ./versions.json.
  # The update process is the following:
  #   * pick the latest commit
  #   * update .invidious.rev, .invidious.version, and .invidious.sha256
  #   * prefetch the videojs dependencies with scripts/fetch-player-dependencies.cr
  #     and update .videojs.sha256 (they are normally fetched during build
  #     but nix's sandboxing does not allow that)
  #   * if shard.lock changed
  #     * recreate shards.nix by running crystal2nix
  #     * update lsquic and boringssl if necessarry, lsquic.cr depends on
  #       the same version of lsquic and lsquic requires the boringssl
  #       commit mentioned in its README
  versions = lib.importJSON ./versions.json;
in
crystal.buildCrystalPackage rec {
  pname = "invidious";
  inherit (versions.invidious) version;

  src = fetchFromGitea {
    domain = "gitea.invidious.io";
    owner = "iv-org";
    repo = pname;
    fetchSubmodules = true;
    inherit (versions.invidious) rev hash;
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
    in
    ''
      for d in ${videojs}/*; do ln -s "$d" assets/videojs; done

      # Use the version metadata from the derivation instead of using git at
      # build-time
      substituteInPlace src/invidious.cr \
          --replace ${lib.escapeShellArg branchTemplate} '"master"' \
          --replace ${lib.escapeShellArg commitTemplate} '"${lib.substring 0 7 versions.invidious.rev}"' \
          --replace ${lib.escapeShellArg versionTemplate} '"${lib.replaceStrings ["-"] ["."] (lib.substring 9 10 version)}"' \
          --replace ${lib.escapeShellArg assetCommitTemplate} '"${lib.substring 0 7 versions.invidious.rev}"'

      # Patch the assets and locales paths to be absolute
      substituteInPlace src/invidious.cr \
          --replace 'public_folder "assets"' 'public_folder "${placeholder "out"}/share/invidious/assets"'
      substituteInPlace src/invidious/helpers/i18n.cr \
          --replace 'File.read("locales/' 'File.read("${placeholder "out"}/share/invidious/locales/'

      # Reference sql initialisation/migration scripts by absolute path
      substituteInPlace src/invidious/database/base.cr \
            --replace 'config/sql' '${placeholder "out"}/share/invidious/config/sql'

      substituteInPlace src/invidious/user/captcha.cr \
          --replace 'Process.run(%(rsvg-convert' 'Process.run(%(${lib.getBin librsvg}/bin/rsvg-convert'
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
      "-Ddisable_quic"
    ];
  };

  postConfigure = ''
    # lib includes nix store paths which can’t be patched, so the links have to
    # be dereferenced first.
    cp -rL lib lib2
    rm -r lib
    mv lib2 lib
    chmod +w -R lib
    cp ${lsquic}/lib/liblsquic.a lib/lsquic/src/lsquic/ext
  '';

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
    INVIDIOUS_CONFIG="$(cat <<EOF
    database_url: sqlite3:///dev/null
    hmac_key: "this-is-required"
    EOF
    )" $out/bin/invidious --help
  '';

  passthru = {
    inherit lsquic;
    tests = { inherit (nixosTests) invidious; };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "An open source alternative front-end to YouTube";
    homepage = "https://invidious.io/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ infinisil sbruder ];
  };
}
