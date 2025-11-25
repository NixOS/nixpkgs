{
  lib,
  nixosTests,
  stdenvNoCC,
  fetchurl,
  crt ? stdenvNoCC.hostPlatform.libc,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mingw_w64-headers";
  version = "13.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${finalAttrs.version}.tar.bz2";
    hash = "sha256-Wv6CKvXE7b9n2q9F7sYdU49J7vaxlSTeZIl8a5WCjK8=";
  };

  configureFlags = [
    (lib.withFeatureAs true "default-msvcrt" crt)
  ];

  preConfigure = ''
    cd mingw-w64-headers
  '';

  passthru = {
    tests = {
      inherit (nixosTests) wine;
    };
    updateScript = ./update.nu;
  };

  meta = {
    homepage = "https://www.mingw-w64.org/";
    downloadPage = "https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/";
    description = "Collection of headers and libraries for building native Windows applications";
    license = with lib.licenses; [
      # Primarily under
      zpl21
      # A couple files
      mit
      # Certain headers imported from Wine
      lgpl21Plus
    ];
    platforms = lib.platforms.windows;
    teams = [ lib.teams.windows ];
  };
})
