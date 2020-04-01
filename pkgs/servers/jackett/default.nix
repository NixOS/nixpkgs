{ lib, stdenv, fetchurl, makeWrapper, curl, icu60, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.13.467";

  src = fetchurl {
    url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxAMDx64.tar.gz";
    sha256 = "1hjihafb8w9gcqdi2i8dmimbbg17c5hwwqhav3avfizq2drsrv5c";
  };

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
    platforms = platforms.linux;
  };
}
