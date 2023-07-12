self: super:
{
  pkg-config = super.pkg-config.overrideAttrs (_: attrs: {
    setupHooks = attrs.setupHooks ++ [
      (self.writeTextFile "emscripten-pkg-config-hook" ''
        export PKG_CONFIG_LIBDIR=${self.emscripten}/share/emscripten/cache/sysroot/lib/pkgconfig
      '')
    ];
  });

  emscriptenLibraries = super.recurseIntoAttrs (super.lib.mapAttrs'
    (name: port: {
      inherit name;
      value = port.asLibrary super.stdenv;
    })
    (with super.buildPackages.emscriptenPorts; {
      inherit bullet bzip2 giflib harfbuzz icu libjpeg libmodplug libpng mpg123 zlib;
      SDL2 = sdl2;
      SDL2_gfx = sdl2_gfx;
      SDL2_image = sdl2_image;
      SDL2_mixer = sdl2_mixer;
      SDL2_net = sdl2_net;
      SDL2_ttf = sdl2_ttf;
      libogg = ogg;
      sqlite = sqlite3;
      libvorbis = vorbis;
    }));

  # Override some packages that don't work with their emscripten port
  inherit (self.emscriptenLibraries) icu;
}
