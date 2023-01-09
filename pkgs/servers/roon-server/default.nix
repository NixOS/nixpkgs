{ alsa-lib
, alsa-utils
, autoPatchelfHook
, cifs-utils
, fetchurl
, ffmpeg
, freetype
, icu66
, krb5
, lib
, libtasn1
, lttng-ust_2_12
, makeWrapper
, openssl
, stdenv
}:
let
  version = "2.0-1182";
  urlVersion = builtins.replaceStrings [ "." "-" ] [ "00" "0" ] version;
in
stdenv.mkDerivation {
  pname = "roon-server";
  inherit version;

  src = fetchurl {
    url = "https://download.roonlabs.com/updates/production/RoonServer_linuxx64_${urlVersion}.tar.bz2";
    hash = "sha256-2mo45+cbOyej5stJ8DFobvqECTTMLandcoPFnD4nY7s=";
  };

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    alsa-lib
    freetype
    krb5
    libtasn1
    lttng-ust_2_12
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase =
    let
      # NB: While this might seem like odd behavior, it's what Roon expects. The
      # tarball distribution provides scripts that do a bunch of nonsense on top
      # of what wrapBin is doing here, so consider it the lesser of two evils.
      # I didn't bother checking whether the symlinks are really necessary, but
      # I wouldn't put it past Roon to have custom code based on the binary
      # name, so we're playing it safe.
      wrapBin = binPath: ''
        (
          binDir="$(dirname "${binPath}")"
          binName="$(basename "${binPath}")"
          dotnetDir="$out/RoonDotnet"

          ln -sf "$dotnetDir/dotnet" "$dotnetDir/$binName"
          rm "${binPath}"
          makeWrapper "$dotnetDir/$binName" "${binPath}" \
            --add-flags "$binDir/$binName.dll" \
            --argv0 "$binName" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ alsa-lib icu66 ffmpeg openssl ]}" \
            --prefix PATH : "$dotnetDir" \
            --prefix PATH : "${lib.makeBinPath [ alsa-utils cifs-utils ffmpeg ]}" \
            --chdir "$binDir" \
            --set DOTNET_ROOT "$dotnetDir"
        )
      '';
    in
    ''
      runHook preInstall
      mkdir -p $out
      mv * $out

      rm $out/check.sh
      rm $out/start.sh
      rm $out/VERSION

      ${wrapBin "$out/Appliance/RAATServer"}
      ${wrapBin "$out/Appliance/RoonAppliance"}
      ${wrapBin "$out/Server/RoonServer"}

      mkdir -p $out/bin
      makeWrapper "$out/Server/RoonServer" "$out/bin/RoonServer" --chdir "$out"

      runHook postInstall
    '';

  meta = with lib; {
    description = "The music player for music lovers";
    changelog = "https://community.roonlabs.com/c/roon/software-release-notes/18";
    homepage = "https://roonlabs.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault steell ];
    platforms = [ "x86_64-linux" ];
  };
}
