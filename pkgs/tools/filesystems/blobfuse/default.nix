{ stdenv, fetchFromGitHub, cmake, pkgconfig, curl, gnutls, libgcrypt, libuuid, fuse }:

stdenv.mkDerivation rec {
  pname = "blobfuse";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner  = "Azure";
    repo   = "azure-storage-fuse";
    rev    = "v${version}";
    sha256 = "1qh04z1fsj1l6l12sz9yl2sy9hwlrnzac54hwrr7wvsgv90n9gbp";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=catch-value";

  buildInputs = [ curl gnutls libgcrypt libuuid fuse ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "Mount an Azure Blob storage as filesystem through FUSE";
    license = licenses.mit;
    maintainers = with maintainers; [ jbgi ];
    platforms = platforms.linux;
  };
}
