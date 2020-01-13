{ stdenv
, fetchurl
, rpmextract
}:

# The raw package that fetches and extracts the Plex RPM. Override the source
# and version of this derivation if you want to use a Plex Pass version of the
# server, and the FHS userenv and corresponding NixOS module should
# automatically pick up the changes.
stdenv.mkDerivation rec {
  version = "1.18.4.2171-ac2afe5f8";
  pname = "plexmediaserver";

  # Fetch the source
  src = fetchurl {
    url = "https://downloads.plex.tv/plex-media-server-new/${version}/redhat/plexmediaserver-${version}.x86_64.rpm";
    sha256 = "10x4cf1c826vj9gqr7r6k70rrjifmi36sd7imfi7pdw5swizjzqv";
  };

  outputs = [ "out" "basedb" ];

  nativeBuildInputs = [ rpmextract ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" "distPhase" ];

  unpackPhase = ''
    rpmextract $src
  '';

  installPhase = ''
    mkdir -p "$out/lib"
    cp -dr --no-preserve='ownership' usr/lib/plexmediaserver $out/lib/

    # Location of the initial Plex plugins database
    f=$out/lib/plexmediaserver/Resources/com.plexapp.plugins.library.db

    # Store the base database in the 'basedb' output
    cat $f > $basedb

    # Overwrite the base database in the Plex package with an absolute symlink
    # to the '/db' file; we create this path in the FHS userenv (see the "plex"
    # package).
    ln -fs /db $f
  '';

  # We're running in a FHS userenv; don't patch anything
  dontPatchShebangs = true;
  dontStrip = true;
  dontPatchELF = true;
  dontAutoPatchelf = true;

  meta = with stdenv.lib; {
    homepage = https://plex.tv/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      colemickens
      forkk
      lnl7
      pjones
      thoughtpolice
    ];
    description = "Media library streaming server";
    longDescription = ''
      Plex is a media server which allows you to store your media and play it
      back across many different devices.
    '';
  };
}
