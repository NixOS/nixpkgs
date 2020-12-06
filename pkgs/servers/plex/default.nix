# The actual Plex package that we run is a FHS userenv of the "raw" package.
{ stdenv
, buildFHSUserEnv
, writeScript
, plexRaw

# Old argument for overriding the Plex data directory; not used for this
# version of Plex, but still around for backwards-compatibility.
, dataDir ? "/var/lib/plex"
}:

buildFHSUserEnv {
  name = "plexmediaserver";
  inherit (plexRaw) meta;

  # This script is run when we start our Plex binary
  runScript = writeScript "plex-run-script" ''
    #!${stdenv.shell}

    set -eu

    # The root path to our Plex installation
    root=${plexRaw}/lib/plexmediaserver

    # Path to where we're storing our Plex data files. We default to storing
    # them in the user's home directory under the XDG-compatible location, but
    # allow overriding with an environment variable so the location can be
    # configured in our NixOS module.
    #
    # NOTE: the old version of Plex used /var/lib/plex as the default location,
    # but this package shouldn't assume that we're going to run Plex with the
    # ability to write to /var/lib, so using a subdirectory of $HOME when none
    # is specified feels less likely to have permission errors.
    if [[ -z "''${PLEX_DATADIR:-}" ]]; then
      PLEX_DATADIR="$HOME/.local/share/plex"
    fi
    if [[ ! -d "$PLEX_DATADIR" ]]; then
      echo "Creating Plex data directory: $PLEX_DATADIR"
      mkdir -p "$PLEX_DATADIR"
    fi

    # The database is stored under the given directory
    db="$PLEX_DATADIR/.skeleton/com.plexapp.plugins.library.db"

    # If we don't have a database in the expected path, then create one by
    # copying our base database to that location.
    if ! test -f "$db"; then
      echo "Copying base database file to: $db"
      mkdir -p "$(dirname "$db")"
      cat "${plexRaw.basedb}" > "$db"
    fi

    # Set up symbolic link at '/db', which is linked to by our Plex package
    # (see the 'plexRaw' package).
    ln -s "$db" /db

    # If we have a plugin list (set by our NixOS module), we create plugins in
    # the data directory as expected. This is a colon-separated list of paths.
    if [[ -n "''${PLEX_PLUGINS:-}" ]]; then
      echo "Preparing plugin directory"

      pluginDir="$PLEX_DATADIR/Plex Media Server/Plug-ins"
      test -d "$pluginDir" || mkdir -p "$pluginDir"

      # First, remove all of the symlinks in the plugins directory.
      echo "Removing old symlinks"
      for f in $(ls "$pluginDir/"); do
        if [[ -L "$pluginDir/$f" ]]; then
          echo "Removing plugin symlink: $pluginDir/$f"
          rm "$pluginDir/$f"
        fi
      done

      echo "Symlinking plugins"
      IFS=':' read -ra pluginsArray <<< "$PLEX_PLUGINS"
      for path in "''${pluginsArray[@]}"; do
        dest="$pluginDir/$(basename "$path")"

        if [[ ! -d "$path" ]]; then
          echo "Error symlinking plugin from $path: no such directory"
        elif [[ -d "$dest" || -L "$dest" ]]; then
          echo "Error symlinking plugin from $path to $dest: file or directory already exists"
        else
          echo "Symlinking plugin at: $path"
          ln -s "$path" "$dest"
        fi
      done
    fi

    # Tell Plex to use the data directory as the "Application Support"
    # directory, otherwise it tries to write things into the user's home
    # directory.
    export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="$PLEX_DATADIR"

    # Tell Plex where the 'home' directory for itself is.
    export PLEX_MEDIA_SERVER_HOME="${plexRaw}/lib/plexmediaserver"

    # Actually run Plex, prepending LD_LIBRARY_PATH with the libraries from
    # the Plex package.
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$root exec "$root/Plex Media Server"
  '';
}
