{ alsaLib, alsaUtils, cifs_utils, fetchurl, ffmpeg, libav, mono, stdenv }:

stdenv.mkDerivation rec {
  name = "roon-server";
  version = "100500363";

  src = fetchurl {
    url = "http://download.roonlabs.com/updates/stable/RoonServer_linuxx64_${version}.tar.bz2";
    sha256 = "1pdlglhmsm0l4k6g4l97ckw596ckw8nnxii60j1xg994kdiikz3s";
  };

  propagatedBuildInputs = [ alsaLib alsaUtils cifs_utils ffmpeg libav mono ];

  installPhase = ''
    # Check script
    sed -i '3i PATH=$PATH:${cifs_utils}/bin:${ffmpeg}/bin:${libav}/bin' check.sh
    sed -i '/check_ulimit$/d' check.sh

    # Start script
    sed -i '3i PATH=$PATH:${alsaUtils}/bin:${cifs_utils}/bin:${ffmpeg}/bin:${libav}/bin' start.sh
    sed -i '4i ROON_DATAROOT=/tmp/roon' start.sh

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
    ln -sf $out/opt/RoonMono/bin/mono-sgen $out/opt/RoonMono/bin/RoonServer
    ln -sf $out/opt/RoonMono/bin/mono-sgen $out/opt/RoonMono/bin/RoonAppliance
    ln -sf $out/opt/RoonMono/bin/mono-sgen $out/opt/RoonMono/bin/RAATServer
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

  meta = with stdenv.lib; {
    description = "The music player for music lovers.";
    homepage    = https://roonlabs.com;
    license     = licenses.unfree;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };
}
