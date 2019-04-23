{ stdenv, fetchurl, autoPatchelfHook, rpmextract
, dataDir ? "/var/lib/plex" # Plex's data directory must be baked into the package due to symlinks.
}:

stdenv.mkDerivation rec {
  name = "plex-${version}";
  version = "1.15.3.876";

  src = fetchurl (if stdenv.hostPlatform.system == "x86_64-linux" then {
    url = "https://downloads.plex.tv/plex-media-server-new/1.15.3.876-ad6e39743/redhat/plexmediaserver-1.15.3.876-ad6e39743.x86_64.rpm";
    sha256 = "01g7wccm01kg3nhf3qrmwcn20nkpv0bqz6zqv2gq5v03ps58h6g5";
  } else if stdenv.hostPlatform.system == "i686-linux" then {
    url = "https://downloads.plex.tv/plex-media-server-new/1.15.3.876-ad6e39743/redhat/plexmediaserver-1.15.3.876-ad6e39743.i686.rpm";
    sha256 = "0ay7brgsh6lwy59b0z84c31kq4n7brsy7m51wk860a1dypqg01k5";
  } else throw "plex: unsupported platform: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" "distPhase" ];

  unpackPhase = ''
    rpmextract $src
  '';

  installPhase = ''
    install -d $out/usr/lib
    cp -dr --no-preserve='ownership' usr/lib/plexmediaserver $out/usr/lib/

    # Mark binaries as executable for autoPatchelfHook
    for f in $out/usr/lib/plexmediaserver/lib/*.so*; do
      chmod +x $f
    done

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

  passthru.updateScript = ./update.sh;

  meta = with stdenv.lib; {
    homepage = http://plex.tv/;
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ colemickens forkk thoughtpolice pjones lnl7 ];
    description = "Media / DLNA server";
    longDescription = ''
      Plex is a media server which allows you to store your media and play it
      back across many different devices.
    '';
  };
}
