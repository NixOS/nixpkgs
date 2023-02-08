{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, which, zlib, openssl, libarchive }:

stdenv.mkDerivation rec {
  pname = "xbps";
  version = "0.59.1";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "xbps";
    rev = version;
    sha256 = "0pab3xf97y4wqlyrb92zxd3cfsrbnlx6pssbw4brgwcxccw9jrhy";
  };

  nativeBuildInputs = [ pkg-config which ];

  buildInputs = [ zlib openssl libarchive ];

  patches = [
    ./cert-paths.patch
    # fix openssl 3
    (fetchpatch {
      url = "https://github.com/void-linux/xbps/commit/db1766986c4389eb7e17c0e0076971b711617ef9.patch";
      hash = "sha256-CmyZdsHStPsELdEgeJBWIbXIuVeBhv7VYb2uGYxzUWQ=";
    })
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result -Wno-error=deprecated-declarations";

  postPatch = ''
    # fix unprefixed ranlib (needed on cross)
    substituteInPlace lib/Makefile \
      --replace 'SILENT}ranlib ' 'SILENT}$(RANLIB) '

    # Don't try to install keys to /var/db/xbps, put in $out/share for now
    substituteInPlace data/Makefile \
      --replace '$(DESTDIR)/$(DBDIR)' '$(DESTDIR)/$(SHAREDIR)'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/void-linux/xbps";
    description = "The X Binary Package System";
    platforms = platforms.linux; # known to not work on Darwin, at least
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
