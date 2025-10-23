{
  lib,
  stdenvNoCC,
  stdenvNoLibc,
  autoreconfHook,
  windows,

  headersOnly ? false,
}:

(if headersOnly then stdenvNoCC else stdenvNoLibc).mkDerivation (
  {
    pname = "w32api${lib.optionalString headersOnly "-headers"}";

    inherit (windows.mingw_w64_headers)
      version
      src
      ;

    outputs = [
      "out"
    ]
    ++ lib.optional (!headersOnly) "dev";

    configureFlags = [ (lib.enableFeature true "w32api") ];

    enableParallelBuilding = true;

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
  }
  // (
    if headersOnly then
      {
        preConfigure = ''
          cd mingw-w64-headers
        '';
      }
    else
      {
        nativeBuildInputs = [ autoreconfHook ];

        hardeningDisable = [
          "stackprotector"
          "fortify"
        ];
      }
  )
)
