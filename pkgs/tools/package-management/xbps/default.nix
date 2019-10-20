{ stdenv, fetchFromGitHub, pkgconfig, which, zlib, openssl, libarchive }:

stdenv.mkDerivation rec {
  pname = "xbps";
  version = "0.57";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "xbps";
    rev = version;
    sha256 = "1aaa0h265lx85hmcvg7zpg7iiq6dzzlyxqazn1s387ss709i5gxn";
  };

  nativeBuildInputs = [ pkgconfig which ];

  buildInputs = [ zlib openssl libarchive ];

  patches = [ ./cert-paths.patch ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=unused-result" ];

  postPatch = ''
    # fix unprefixed ranlib (needed on cross)
    substituteInPlace lib/Makefile \
      --replace 'SILENT}ranlib ' 'SILENT}$(RANLIB) '

    # Don't try to install keys to /var/db/xbps, put in $out/share for now
    substituteInPlace data/Makefile \
      --replace '$(DESTDIR)/$(DBDIR)' '$(DESTDIR)/$(SHAREDIR)'
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/void-linux/xbps;
    description = "The X Binary Package System";
    platforms = platforms.linux; # known to not work on Darwin, at least
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
