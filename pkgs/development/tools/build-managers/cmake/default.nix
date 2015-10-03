{ stdenv, fetchurl, pkgconfig
, bzip2, curl, expat, libarchive, xz, zlib
, useNcurses ? false, ncurses, useQt4 ? false, qt4
, wantPS ? false, ps ? null
}:

with stdenv.lib;

assert wantPS -> (ps != null);

let
  os = stdenv.lib.optionalString;
  majorVersion = "3.3";
  minorVersion = "2";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    sha256 = "08pwy9ip9cgwgynhn5vrjw8drw29gijy1rmziq22n65zds6ifnp7";
  };

  patches =
    # Don't search in non-Nix locations such as /usr, but do search in
    # Nixpkgs' Glibc.
    optional (stdenv ? glibc) ./search-path-3.2.patch ++
    optional (stdenv ? cross) (fetchurl {
      name = "fix-darwin-cross-compile.patch";
      url = "http://public.kitware.com/Bug/file_download.php?"
          + "file_id=4981&type=bug";
      sha256 = "16acmdr27adma7gs9rs0dxdiqppm15vl3vv3agy7y8s94wyh4ybv";
    }) ++ stdenv.lib.optional stdenv.isCygwin ./3.2.2-cygwin.patch;

  outputs = [ "out" "doc" ];
  setOutputFlags = false;

  setupHook = ./setup-hook.sh;

  buildInputs =
    [ setupHook pkgconfig bzip2 curl expat libarchive xz zlib ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  propagatedBuildInputs = optional wantPS ps;

  preConfigure = with stdenv; optionalString (stdenv ? glibc)
    ''
      fixCmakeFiles .
      substituteInPlace Modules/Platform/UnixPaths.cmake \
        --subst-var-by glibc_bin ${glibc.bin or glibc} \
        --subst-var-by glibc_dev ${glibc.dev or glibc} \
        --subst-var-by glibc_lib ${glibc.out or glibc}
    '';
  configureFlags =
    [ "--docdir=/share/doc/${name}"
      "--no-system-jsoncpp"
    ]
    ++ optional (!stdenv.isCygwin) "--system-libs"
    ++ optional useQt4 "--qt-gui"
    ++ ["--"]
    ++ optional (!useNcurses) "-DBUILD_CursesDialog=OFF";

  dontUseCmakeConfigure = true;

  enableParallelBuilding = true;

  preInstall = ''mkdir "$doc" '';

  postInstall = ''_moveToOutput "share/cmake-*/Help" "$doc" '';

  meta = with stdenv.lib; {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else platforms.all;
    maintainers = with maintainers; [ urkud mornfall ttuegel ];
  };
}
