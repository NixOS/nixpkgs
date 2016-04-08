{ stdenv, fetchurl, rpmextract, glibc
, dataDir ? "/var/lib/plex" # Plex's data directory must be baked into the package due to symlinks.
, enablePlexPass ? false
}:

let
  plexpkg = if enablePlexPass then {
    version = "0.9.16.4.1911";
    vsnHash = "ee6e505";
    sha256 = "0lq0lcynmc09d0whynb0x2zgd39dp7z7k86ndgm2clay3zbzqpfd";
  } else {
    version = "0.9.16.4.1911";
    vsnHash = "ee6e505";
    sha256 = "0lq0lcynmc09d0whynb0x2zgd39dp7z7k86ndgm2clay3zbzqpfd";
  };

in stdenv.mkDerivation rec {
  name = "plex-${version}";
  version = plexpkg.version;
  vsnHash = plexpkg.vsnHash;
  sha256 = plexpkg.sha256;

  src = fetchurl {
    url = "https://downloads.plex.tv/plex-media-server/${version}-${vsnHash}/plexmediaserver-${version}-${vsnHash}.x86_64.rpm";
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
    for bin in "Plex Media Server" "Plex DLNA Server" "Plex Media Scanner"; do
      patchelf --set-interpreter "${glibc}/lib/ld-linux-x86-64.so.2" "$out/usr/lib/plexmediaserver/$bin"
      patchelf --set-rpath "$out/usr/lib/plexmediaserver" "$out/usr/lib/plexmediaserver/$bin"
    done

    find $out/usr/lib/plexmediaserver/Resources -type f -a -perm -0100 \
        -print -exec patchelf --set-interpreter "${glibc}/lib/ld-linux-x86-64.so.2" '{}' \;

    # executables need libstdc++.so.6
    ln -s "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}/libstdc++.so.6" "$out/usr/lib/plexmediaserver/libstdc++.so.6"

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
        ln -s ${dataDir}/.skeleton/$db $RSC/$db
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://plex.tv/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ colemickens forkk thoughtpolice ];
    description = "Media / DLNA server";
    longDescription = ''
      Plex is a media server which allows you to store your media and play it
      back across many different devices.
    '';
  };
}
