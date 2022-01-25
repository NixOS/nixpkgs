{ lib, crystal, fetchFromGitHub, librsvg, pkg-config, libxml2, openssl, sqlite, lsquic, nixosTests }:
let
  # When updating, always update the following:
  #  * the git revision
  #  * the version attribute
  #  * the source hash (sha256)
  # If the shards.lock file changed, also the following:
  #  * shards.nix (by running `crystal2nix` in invidious’ source tree)
  #  * If the lsquic.cr dependency changed: lsquic in lsquic.nix (version, sha256)
  #  * If the lsquic version changed: boringssl' in lsquic.nix (version, sha256)
  rev = "21879da80d2dfa97e789a13b90e82e466c4854e3";
in
crystal.buildCrystalPackage rec {
  pname = "invidious";
  version = "unstable-2021-11-08";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = pname;
    inherit rev;
    sha256 = "0jvnwjdh2l0hxfvzim00r3zbs528bb93y1nk0bjrbbrcfv5cn5ss";
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
      # Use the version metadata from the derivation instead of using git at
      # build-time
      substituteInPlace src/invidious.cr \
          --replace ${lib.escapeShellArg branchTemplate} '"master"' \
          --replace ${lib.escapeShellArg commitTemplate} '"${lib.substring 0 7 rev}"' \
          --replace ${lib.escapeShellArg versionTemplate} '"${lib.replaceChars ["-"] ["."] (lib.substring 9 10 version)}"' \
          --replace ${lib.escapeShellArg assetCommitTemplate} '"${lib.substring 0 7 rev}"'

      # Patch the assets and locales paths to be absolute
      substituteInPlace src/invidious.cr \
          --replace 'public_folder "assets"' 'public_folder "${placeholder "out"}/share/invidious/assets"'
      substituteInPlace src/invidious/helpers/i18n.cr \
          --replace 'File.read("locales/' 'File.read("${placeholder "out"}/share/invidious/locales/'

      # Reference sql initialisation/migration scripts by absolute path
      substituteInPlace src/invidious/helpers/helpers.cr \
            --replace 'config/sql' '${placeholder "out"}/share/invidious/config/sql'

      substituteInPlace src/invidious/users.cr \
          --replace 'Process.run(%(rsvg-convert' 'Process.run(%(${lib.getBin librsvg}/bin/rsvg-convert'
    '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxml2 openssl sqlite ];

  format = "crystal";
  shardsFile = ./shards.nix;
  crystalBinaries.invidious.src = "src/invidious.cr";

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

  # Invidious tries to open config/config.yml and connect to the database, even
  # when running --help. This specifies a minimal configuration in an
  # environment variable. Even though the database is bogus, --help still
  # works.
  installCheckPhase = ''
    INVIDIOUS_CONFIG="database_url: sqlite3:///dev/null" $out/bin/invidious --help
  '';

  passthru.tests = { inherit (nixosTests) invidious; };

  meta = with lib; {
    description = "An open source alternative front-end to YouTube";
    homepage = "https://invidious.io/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ infinisil sbruder ];
  };
}
