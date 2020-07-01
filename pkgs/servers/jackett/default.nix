{ lib, stdenv, fetchurl, makeWrapper, curl, icu60, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.16.175";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxAMDx64.tar.gz";
      sha512 = "269n84qc8sfrmnidgrjywanbqr65mhkmk24dlqfi17pi0l27wi4fc4qmnjj683xwprz5hqjsmkqf963pbx4k3jaz0rp0jnizan91wij";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxARM64.tar.gz";
      sha512 = "0dmyhprd2vi2z9q5g79psqgsc3w0zdac4s6k20rngi8jxm5jgphzrzcic4rgdijyryap99my619k447w701a08vh9sfcfk0fjg9pgwb";
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
