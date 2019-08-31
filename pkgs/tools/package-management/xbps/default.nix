{ stdenv, fetchFromGitHub, pkgconfig, which, zlib, openssl, libarchive }:

stdenv.mkDerivation rec {
  pname = "xbps";
  version = "0.56";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "xbps";
    rev = version;
    sha256 = "0hqvq6fq62l5sgm4fy3zb0ks889d21mqz4f4my3iifs6c9f50na2";
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
    homepage = https://github.com/void-linux/xbps;
    description = "The X Binary Package System";
    platforms = platforms.linux; # known to not work on Darwin, at least
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
