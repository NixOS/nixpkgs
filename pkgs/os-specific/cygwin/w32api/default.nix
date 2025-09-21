{
  lib,
  stdenvNoCC,
  windows,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "w32api-headers";

  inherit (windows.mingw_w64_headers)
    version
    src
    ;

  configureFlags = [ (lib.enableFeature true "w32api") ];

  preConfigure = ''
    cd mingw-w64-headers
  '';

  passthru = {
    incdir = "/include/w32api/";
    libdir = "/lib/w32api/";
  };

  meta = {
    description = "MinGW w32api package for Cygwin";
    inherit (windows.mingw_w64_headers.meta)
      homepage
      downloadPage
      license
      ;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    teams = [ lib.maintainers.corngood ];
  };
})
