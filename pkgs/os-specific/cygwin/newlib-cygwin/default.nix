{
  lib,
  stdenvNoCC,
  buildPackages,
  fetchurl,
  w32api-headers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "newlib-cygwin-headers";
  version = "3.6.4";

  src = buildPackages.fetchgit {
    url = "https://cygwin.com/git/newlib-cygwin.git";
    rev = "cygwin-${finalAttrs.version}";
    hash = "sha256-+WYKwqcDAc7286GzbgKKAxNJCOf3AeNnF8XEVPoor+g=";
  };

  patches = [
    # newer versions of gcc don't like struct winsize being used before being
    # declared.
    ./fix-winsize.patch
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include/
    cp -r newlib/libc/include/* $out/include/
    cp -r winsup/cygwin/include/* $out/include/
  '';

  passthru.w32api = w32api-headers;

  meta = {
    homepage = "https://cygwin.com/";
    description = "A DLL which provides substantial POSIX API functionality on Windows.";
    license = with lib.licenses; [
      # newlib
      gpl2
      # winsup
      gpl3
    ];
    platforms = lib.platforms.cygwin;
    maintainers = [ lib.maintainers.corngood ];
  };
})
