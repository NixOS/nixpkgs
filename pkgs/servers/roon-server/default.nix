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
, makeWrapper
, stdenv
, openssl
}:
stdenv.mkDerivation rec {
  pname = "roon-server";
  version = "1.8-903";

  src =
    let
      urlVersion = builtins.replaceStrings [ "." "-" ] [ "00" "00" ] version;
    in
    fetchurl {
      url = "http://download.roonlabs.com/builds/RoonServer_linuxx64_${urlVersion}.tar.bz2";
      sha256 = "sha256-FkB3sh1uwOctBOAW7eO8HFNr9a9RG3Yq4hKKscYYER4=";
    };

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    alsa-lib
    freetype
    krb5
    libtasn1
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
            --run "cd $binDir" \
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
      makeWrapper "$out/Server/RoonServer" "$out/bin/RoonServer" --run "cd $out"

      # This is unused and depends on an ancient version of lttng-ust, so we
      # just patch it out
      patchelf --remove-needed liblttng-ust.so.0 $out/RoonDotnet/shared/Microsoft.NETCore.App/5.0.0/libcoreclrtraceptprovider.so

      runHook postInstall
    '';

  meta = with lib; {
    description = "The music player for music lovers";
    changelog = "https://community.roonlabs.com/c/roon/software-release-notes/18";
    homepage = "https://roonlabs.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault steell ];
    platforms = [ "x86_64-linux" ];
  };
}
