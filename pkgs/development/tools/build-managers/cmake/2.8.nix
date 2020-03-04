{ stdenv, fetchurl, fetchpatch, curl, expat, zlib, bzip2
, useNcurses ? false, ncurses, useQt4 ? false, qt4, ps
}:

with stdenv.lib;

assert stdenv ? cc;
assert stdenv.cc ? libc;

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
    [(fetchpatch { # see https://www.cmake.org/Bug/view.php?id=13959
      name = "FindFreetype-2.5.patch";
      url = "https://public.kitware.com/Bug/file/4660/0001-Support-finding-freetype2-using-pkg-config.patch";
      sha256 = "136z63ff83hnwd247cq4m8m8164pklzyl5i2csf5h6wd8p01pdkj";
    })] ++
    # Don't search in non-Nix locations such as /usr, but do search in our libc.
    [ ./search-path-2.8.patch ] ++
    optional (stdenv.hostPlatform != stdenv.buildPlatform) (fetchurl {
      name = "fix-darwin-cross-compile.patch";
      url = "https://public.kitware.com/Bug/file_download.php?"
          + "file_id=4981&type=bug";
      sha256 = "16acmdr27adma7gs9rs0dxdiqppm15vl3vv3agy7y8s94wyh4ybv";
    });

  postPatch = ''
    substituteInPlace Utilities/cmlibarchive/CMakeLists.txt \
      --replace '"-framework CoreServices"' '""'
  '';

  buildInputs = [ setupHook curl expat zlib bzip2 ]
    ++ optional useNcurses ncurses
    ++ optional useQt4 qt4;

  propagatedBuildInputs = [ ps ];

  CMAKE_PREFIX_PATH = concatStringsSep ":"
    (concatMap (p: [ (p.dev or p) (p.out or p) ]) buildInputs);

  configureFlags = [
    "--docdir=/share/doc/${name}"
    "--mandir=/share/man"
    "--system-libs"
    "--no-system-libarchive"
   ] ++ stdenv.lib.optional useQt4 "--qt-gui";

  setupHook = ./setup-hook.sh;

  dontUseCmakeConfigure = true;

  preConfigure = with stdenv; ''
      fixCmakeFiles .
      substituteInPlace Modules/Platform/UnixPaths.cmake \
        --subst-var-by libc_bin ${getBin cc.libc} \
        --subst-var-by libc_dev ${getDev cc.libc} \
        --subst-var-by libc_lib ${getLib cc.libc}
      configureFlags="--parallel=''${NIX_BUILD_CORES:-1} $configureFlags"
    '';

  hardeningDisable = [ "format" ];

  meta = {
    homepage = https://cmake.org;
    description = "Cross-Platform Makefile Generator";
    platforms = if useQt4 then qt4.meta.platforms else stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ xfix ];
    license = stdenv.lib.licenses.bsd3;
  };
}
