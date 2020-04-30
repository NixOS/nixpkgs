{ lib, stdenv, fetchurl, makeWrapper, curl, icu60, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.14.365";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxAMDx64.tar.gz";
      sha512 = "28dgaap4aj1ldcfr0lzgz2aq1lbk8vlgbmjwfg4m4s4rlmiadw6wkxy9w7h4fq7gqbj51q8xxqz6y50jfzn124bs9wgi8br4lk3hsw3";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxARM64.tar.gz";
      sha512 = "0kv95yg775lq7lgc4b75rdqfsyzfcj2a1bj0cmhzpjk4sbsg3jayqgjzbhl5h79r9si1y8b7lg8ffl2j83rwap8wyq1dqdjls4savfb";
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
