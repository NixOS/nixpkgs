{ config, stdenv, fetchurl, rpmextract, glibc
, dataDir ? "/var/lib/plex" # Plex's data directory must be baked into the package due to symlinks.
, enablePlexPass ? config.plex.enablePlexPass or false
}:

let
  plexPass = throw "Plex pass has been removed at upstream's request; please unset nixpkgs.config.plex.pass";
  plexpkg = if enablePlexPass then plexPass else {
    version = "1.15.3.876";
    vsnHash = "ad6e39743";
    sha256 = "01g7wccm01kg3nhf3qrmwcn20nkpv0bqz6zqv2gq5v03ps58h6g5";
  };

in stdenv.mkDerivation rec {
  name = "plex-${version}";
  version = plexpkg.version;
  vsnHash = plexpkg.vsnHash;
  sha256 = plexpkg.sha256;

  src = fetchurl {
    url = "https://downloads.plex.tv/plex-media-server-new/${version}-${vsnHash}/redhat/plexmediaserver-${version}-${vsnHash}.x86_64.rpm";
    inherit sha256;
  };

  buildInputs = [ rpmextract glibc ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" "distPhase" ];

  unpackPhase = ''
    rpmextract $src
  '';

  installPhase = ''
    install -d $out/usr/lib
    cp -dr --no-preserve='ownership' usr/lib/plexmediaserver $out/usr/lib/

    # Now we need to patch up the executables and libraries to work on Nix.
    # Side note: PLEASE don't put spaces in your binary names. This is stupid.
    for bin in "Plex Media Server"              \
               "Plex Commercial Skipper"        \
               "Plex DLNA Server"               \
               "Plex Media Scanner"             \
               "Plex Relay"                     \
               "Plex Script Host"               \
               "Plex Transcoder"                \
               "Plex Tuner Service"             ; do
      patchelf --set-interpreter "${glibc.out}/lib/ld-linux-x86-64.so.2" "$out/usr/lib/plexmediaserver/$bin"
      patchelf --set-rpath "$out/usr/lib/plexmediaserver/lib" "$out/usr/lib/plexmediaserver/$bin"
    done

    find $out/usr/lib/plexmediaserver/Resources -type f -a -perm -0100 \
        -print -exec patchelf --set-interpreter "${glibc.out}/lib/ld-linux-x86-64.so.2" '{}' \;

    # Our next problem is the "Resources" directory in /usr/lib/plexmediaserver.
    # This is ostensibly a skeleton directory, which contains files that Plex
    # copies into its folder in /var. Unfortunately, there are some SQLite
    # databases in the directory that are opened at startup. Since these
    # database files are read-only, SQLite chokes and Plex fails to start. To
    # solve this, we keep the resources directory in the Nix store, but we
    # rename the database files and replace the originals with symlinks to
    # /var/lib/plex. Then, in the systemd unit, the base database files are
    # copied to /var/lib/plex before starting Plex.
    RSC=$out/usr/lib/plexmediaserver/Resources
    for db in "com.plexapp.plugins.library.db"; do
        mv $RSC/$db $RSC/base_$db
        ln -s "${dataDir}/.skeleton/$db" $RSC/$db
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://plex.tv/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ colemickens forkk thoughtpolice pjones lnl7 ];
    description = "Media / DLNA server";
    longDescription = ''
      Plex is a media server which allows you to store your media and play it
      back across many different devices.
    '';
  };
}
