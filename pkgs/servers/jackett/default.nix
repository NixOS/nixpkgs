{ lib, stdenv, fetchurl, makeWrapper, curl, icu60, openssl, zlib }:

let
  arch =
    with stdenv.hostPlatform;
    if isx86_64 then "AMDx64"
    else if isAarch32 then "ARM32"
    else if isAarch64 then "ARM64"
    else abort "Unsupported architecture";
in stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.12.907";

  src = fetchurl {
    url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.Linux${arch}.tar.gz";
    sha256 = with stdenv.hostPlatform;
             if isAarch64 then "10vv8lf4gz4xm8862fhwvv6v06ycc7xl7pcqz2cf0mfq1l1xailq"
             else if isAarch32 then "0547m70lxdpxgmid9z4la9a9w51d0d0xnavw1jk7vplzrv7y2i8z"
             else "0f88zjd8abkr72sjbzm51npxsjbk6xklfqd7iyaq3j0l5hxh6b8w";
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
    homepage = https://github.com/Jackett/Jackett/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo nyanloutre ];
    platforms = platforms.linux;
  };
}
