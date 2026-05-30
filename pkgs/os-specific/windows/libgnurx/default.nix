{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libgnurx";
  version = "2.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/mingw/Other/UserContributed/regex/mingw-regex-${finalAttrs.version}/mingw-libgnurx-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-cUe3+AbsPQB4Q7OOGfQqW3xliUpX/8KXp2sNzV9nXXY=";
  };

  # file looks for libgnurx.a when compiling statically
  postInstall = lib.optionalString stdenv.hostPlatform.isStatic ''
    ln -s $out/lib/libgnurx{.dll.a,.a}
  '';

  meta = {
    downloadPage = "https://sourceforge.net/projects/mingw/files/Other/UserContributed/regex/";
    description = "Regex functionality from glibc extracted into a separate library for win32";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.windows;
    teams = [ lib.teams.windows ];
  };
})
