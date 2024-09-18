{ bzip2
, coreutils
, cpio
, fetchurl
, gnutar
, gzip
, lib
, stdenv
, xz
, zstd
}:

stdenv.mkDerivation rec {
  pname = "rpm2targz";
  version = "2021.03.16";

  # git repo: https://gitweb.gentoo.org/proj/rpm2targz.git/
  src = fetchurl {
    url = "https://dev.gentoo.org/~vapier/dist/${pname}-${version}.tar.xz";
    hash = "sha256-rcV+o9V2wWKznqSW2rA8xgnpQ02kpK4te6mYvLRC5vQ=";
  };

  postPatch = let
    shdeps = [
      bzip2
      coreutils
      cpio
      gnutar
      gzip
      xz
      zstd
    ];
  in ''
    substituteInPlace rpm2targz --replace "=\"rpmoffset\"" "=\"$out/bin/rpmoffset\""
    # rpm2targz relies on the executable name
    # to guess what compressor it should use
    # this is more reliable than wrapProgram
    sed -i -e '2iexport PATH="${lib.makeBinPath shdeps}"' rpm2targz
  '';

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Convert a .rpm file to a .tar.gz archive";
    homepage = "http://slackware.com/config/packages.php";
    license = licenses.bsd1;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
