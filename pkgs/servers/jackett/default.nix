{ lib, stdenv, fetchurl, makeWrapper, curl, icu60, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.16.949";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxAMDx64.tar.gz";
      sha256 = "1yy72ja18jk8b396749wmvhkl0001abjcadkhjqs3i0gvrrz37g3";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxARM64.tar.gz";
      sha256 = "113x0rjf2yjf813nwciifzja0k2wl5qfi7yh0vrjfjlahi0gfsxl";
    };
  }."${stdenv.targetPlatform.system}" or (throw "Missing hash for host system: ${stdenv.targetPlatform.system}");

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,opt/${pname}-${version}}
    cp -r * $out/opt/${pname}-${version}

    makeWrapper "$out/opt/${pname}-${version}/jackett" $out/bin/Jackett \
      --prefix LD_LIBRARY_PATH ':' "${curl.out}/lib:${icu60.out}/lib:${openssl.out}/lib:${zlib.out}/lib"
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib  # libstdc++.so.6
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/opt/${pname}-${version}/jackett
  '';

  meta = with stdenv.lib; {
    description = "API Support for your favorite torrent trackers.";
    homepage = "https://github.com/Jackett/Jackett/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo nyanloutre ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
