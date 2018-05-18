{ stdenv, fetchFromGitHub, pkgconfig, which, zlib, openssl, libarchive }:

stdenv.mkDerivation rec {
  name = "xbps-${version}";
  version = "0.52";

  src = fetchFromGitHub {
    owner = "voidlinux";
    repo = "xbps";
    rev = version;
    sha256 = "1sf6iy9l3dijsczsngzbhksshfm1374g2rrdasc04l6gz35l2cdp";
  };

  nativeBuildInputs = [ pkgconfig which ];

  buildInputs = [ zlib openssl libarchive ];

  patches = [ ./cert-paths.patch ];

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
    homepage = https://github.com/voidlinux/xbps;
    description = "The X Binary Package System";
    platforms = platforms.linux; # known to not work on Darwin, at least
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
