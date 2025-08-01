{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "2.5.1";
in
stdenv.mkDerivation rec {
  pname = "libgnurx";
  inherit version;
  src = fetchurl {
    url = "mirror://sourceforge/mingw/Other/UserContributed/regex/mingw-regex-${version}/mingw-${pname}-${version}-src.tar.gz";
    sha256 = "0xjxcxgws3bblybw5zsp9a4naz2v5bs1k3mk8dw00ggc0vwbfivi";
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
}
