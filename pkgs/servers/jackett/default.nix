{ lib, stdenv, fetchurl, makeWrapper, curl, icu60, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.16.1023";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxAMDx64.tar.gz";
      sha512 = "11cqj0iwy389n8v2xc862flbi09pppl14zz90xa6h0pkrwinlba9gai36l0iafsa9blfb17a1ysidn3ny1ipy8frvp3xgd8lq7ypd4i";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxARM64.tar.gz";
      sha512 = "1aw28mw07sngjjbazd6rzr03x45a6wljlfrqykqimlxm15khl4hj9hz11rcg0cp44fx4q7mb72r856mh5azlc0lrvh3i3sh4jgy3b6a";
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
