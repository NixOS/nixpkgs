{ lib, stdenv, fetchzip, Carbon, Cocoa, ScriptingBridge }:

stdenv.mkDerivation rec {
  pname = "chunkwm";
  version = "0.4.9";
  src = fetchzip {
    url = "https://github.com/koekeishiya/chunkwm/archive/v${version}.tar.gz";
    sha256 = "0w8q92q97fdvbwc3qb5w44jn4vi3m65ssdvjp5hh6b7llr17vspl";
  };

  buildInputs = [ Carbon Cocoa ScriptingBridge ];
  outputs = [ "bin" "out" ];

  buildPhase = ''
    for d in . src/chunkc src/plugins/*; do
        pushd $d
        buildPhase
        popd
    done
  '';

  installPhase = ''
    mkdir -p $bin/bin $out/bin $out/lib/chunkwm/plugins
    cp src/chunkc/bin/chunkc $bin/bin/chunkc
    cp bin/chunkwm $out/bin
    cp plugins/*.so $out/lib/chunkwm/plugins
  '';

  meta = with lib; {
    description = "Tiling window manager for macOS based on plugin architecture";
    homepage = "https://github.com/koekeishiya/chunkwm";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lnl7 ];
    license = licenses.mit;
  };
}
