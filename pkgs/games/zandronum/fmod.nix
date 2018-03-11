{ stdenv, lib, fetchurl, alsaLib, libpulseaudio }:

let
  bits = stdenv.lib.optionalString (stdenv.system == "x86_64-linux") "64";
  libPath = lib.makeLibraryPath [ stdenv.cc.cc alsaLib libpulseaudio ];

in
stdenv.mkDerivation rec {
  name = "fmod-${version}";
  version = "4.44.64";

  src = fetchurl {
    url = "https://zdoom.org/files/fmod/fmodapi44464linux.tar.gz";
    sha256 = "047hk92xapwwqj281f4zwl0ih821rrliya70gfj82sdfjh9lz8i1";
  };

  dontStrip = true;
  dontPatchELF = true;
  dontBuild = true;

  installPhase = ''
    install -Dm755 api/lib/libfmodex${bits}-${version}.so $out/lib/libfmodex-${version}.so
    ln -s libfmodex-${version}.so $out/lib/libfmodex.so
    patchelf --set-rpath ${libPath} $out/lib/libfmodex.so
    cp -r api/inc $out/include
  '';

  meta = with stdenv.lib; {
    description = "Programming library and toolkit for the creation and playback of interactive audio";
    homepage    = http://www.fmod.org/;
    license     = licenses.unfreeRedistributable;
    platforms   = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.lassulus ];
  };
}
