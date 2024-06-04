{ lib, stdenv
, fetchurl
, dpkg
, writeScript
, curl
, jq
, common-updater-scripts
}:

# The raw package that fetches and extracts the Plex RPM. Override the source
# and version of this derivation if you want to use a Plex Pass version of the
# server, and the FHS userenv and corresponding NixOS module should
# automatically pick up the changes.
stdenv.mkDerivation rec {
  version = "1.40.2.8395-c67dce28e";
  pname = "plexmediaserver";

  # Fetch the source
  src = if stdenv.hostPlatform.system == "aarch64-linux" then fetchurl {
    url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_arm64.deb";
    sha256 = "sha256-ZJqbE9pgflqFVjiDqCED6K5KBk6KHSbkIQllF06jJVQ=";
  } else fetchurl {
    url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
    sha256 = "sha256-gYRhQIf6RaXgFTaigFW1yJ7ndxRmOP6oJSNnr8o0EBM=";
  };

  outputs = [ "out" "basedb" ];

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -R $src .
  '';

  installPhase = ''
    runHook preInstall
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
    runHook postInstall
  '';

  # We're running in a FHS userenv; don't patch anything
  dontPatchShebangs = true;
  dontStrip = true;
  dontPatchELF = true;
  dontAutoPatchelf = true;

  passthru.updateScript = writeScript "${pname}-updater" ''
    #!${stdenv.shell}
    set -eu -o pipefail
    PATH=${lib.makeBinPath [curl jq common-updater-scripts]}:$PATH

    plexApiJson=$(curl -sS https://plex.tv/api/downloads/5.json)
    latestVersion="$(echo $plexApiJson | jq .computer.Linux.version | tr -d '"\n')"

    for platform in ${lib.concatStringsSep " " meta.platforms}; do
      arch=$(echo $platform | cut -d '-' -f1)
      dlUrl="$(echo $plexApiJson | jq --arg arch "$arch" -c '.computer.Linux.releases[] | select(.distro == "debian") | select(.build | contains($arch)) .url' | tr -d '"\n')"

      latestSha="$(nix-prefetch-url $dlUrl)"

      # The script will not perform an update when the version attribute is up to date from previous platform run
      # We need to clear it before each run
      update-source-version plexRaw 0 $(yes 0 | head -64 | tr -d "\n") --system=$platform
      update-source-version plexRaw "$latestVersion" "$latestSha" --system=$platform
    done
  '';

  meta = with lib; {
    homepage = "https://plex.tv/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [
      badmutex
      forkk
      lnl7
      pjones
      thoughtpolice
      MayNiklas
    ];
    description = "Media library streaming server";
    longDescription = ''
      Plex is a media server which allows you to store your media and play it
      back across many different devices.
    '';
  };
}
