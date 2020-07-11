{ alsaLib, alsaUtils, cifs-utils, fetchurl, ffmpeg_3, libav, zlib, stdenv }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "roon-server";
  version = "100700571";

  src = fetchurl {
    url = "http://download.roonlabs.com/updates/stable/RoonServer_linuxx64_${version}.tar.bz2";
    sha256 = "191vlzf10ypkk1prp6x2rszlmsihdwpd3wvgf2jg6ckwyxy2hc6k";
  };

  installPhase = ''
    runHook preInstall

    # Check script
    sed -i '3i PATH=$PATH:${makeBinPath [ cifs-utils ffmpeg_3 libav ]}' check.sh
    sed -i '/check_ulimit$/d' check.sh

    # Start script
    sed -i '3i PATH=$PATH:${makeBinPath [ alsaUtils cifs-utils ffmpeg_3 libav ]}' start.sh

    # Debug logging
    sed -i '/--debug--gc=sgen --server/exec "$HARDLINK" --debug --gc=sgen --server "$SCRIPT.exe" "$@" -storagetrace -watchertrace' Appliance/RoonAppliance

    # Binaries
    sed -i '/# boost ulimit/,+2 d' Appliance/RAATServer
    sed -i '/# boost ulimit/,+2 d' Appliance/RoonAppliance
    sed -i '/# boost ulimit/,+2 d' Server/RoonServer
    sed -i '/ln -sf/ d' Appliance/RAATServer
    sed -i '/ln -sf/ d' Appliance/RoonAppliance
    sed -i '/ln -sf/ d' Server/RoonServer
    mkdir -p $out/opt
    mv * $out/opt
    ln -s ${zlib}/lib/libz.so.1 $out/opt/RoonMono/lib/libz.so.1
    ln -sf $out/opt/RoonMono/bin/mono-sgen $out/opt/RoonMono/bin/RoonServer
    ln -sf $out/opt/RoonMono/bin/mono-sgen $out/opt/RoonMono/bin/RoonAppliance
    ln -sf $out/opt/RoonMono/bin/mono-sgen $out/opt/RoonMono/bin/RAATServer

    runHook postInstall
  '';

  preFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${alsaLib}/lib" \
      $out/opt/RoonMono/bin/mono-sgen

    # Checkers
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${alsaLib}/lib" \
      $out/opt/Appliance/check_alsa
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/opt/Appliance/check_bincompat
  '';

  meta = {
    description = "The music player for music lovers.";
    homepage    = "https://roonlabs.com";
    license     = licenses.unfree;
    maintainers = with maintainers; [ steell ];
    platforms   = platforms.linux;
  };
}
