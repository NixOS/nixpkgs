{ stdenv, fetchurl, fetchpatch, replace, curl, expat, zlib, bzip2, libarchive
, useNcurses ? false, ncurses, useQt4 ? false, qt4, wantPS ? false, ps ? null
}:

with stdenv.lib;

assert wantPS -> (ps != null);

let
  os = stdenv.lib.optionalString;
  majorVersion = "2.8";
  minorVersion = "12.2";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "cmake-${os useNcurses "cursesUI-"}${os useQt4 "qt4UI-"}${version}";

  inherit majorVersion;

  src = fetchurl {
    url = "${meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
    sha256 = "0phf295a9cby0v7zqdswr238v5aiy3rb2fs6dz39zjxbmzlp8rcc";
  };

  enableParallelBuilding = true;

  patches =
    [(fetchpatch { # see http://www.cmake.org/Bug/view.php?id=13959
      name = "FindFreetype-2.5.patch";
      url = "http://www.cmake.org/Bug/file_download.php?file_id=4660&type=bug";
      sha256 = "136z63ff83hnwd247cq4m8m8164pklzyl5i2csf5h6wd8p01pdkj";
    })] ++
    # Don't search in non-Nix locations such as /usr, but do search in
    # Nixpkgs' Glibc. 
    optional (stdenv ? glibc) ./search-path.patch ++
    optional (stdenv ? cross) (fetchurl {
      name = "fix-darwin-cross-compile.patch";
      url = "http://public.kitware.com/Bug/file_download.php?"
          + "file_id=4981&type=bug";
      sha256 = "16acmdr27adma7gs9rs0dxdiqppm15vl3vv3agy7y8s94wyh4ybv";
    });

  buildInputs = [ curl expat zlib bzip2 libarchive ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  propagatedBuildInputs = optional wantPS ps;

  CMAKE_PREFIX_PATH = concatStringsSep ":"
    (concatMap (p: [ (p.dev or p) (p.out or p) ]) buildInputs);

  configureFlags =
    "--docdir=/share/doc/${name} --mandir=/share/man --system-libs"
    + stdenv.lib.optionalString useQt4 " --qt-gui";

  setupHook = ./setup-hook.sh;

  dontUseCmakeConfigure = true;

  preConfigure = with stdenv; optionalString (stdenv ? glibc)
    ''
      source $setupHook
      fixCmakeFiles .
      substituteInPlace Modules/Platform/UnixPaths.cmake \
        --subst-var-by glibc_bin ${getBin glibc} \
        --subst-var-by glibc_dev ${getDev glibc} \
        --subst-var-by glibc_lib ${getLib glibc}
    '';

  meta = {
    homepage = http://www.cmake.org/;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ urkud mornfall ];
  };
}
