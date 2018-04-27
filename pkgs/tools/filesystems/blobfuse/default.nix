{ stdenv, fetchFromGitHub, cmake, pkgconfig, curl, gnutls, libgcrypt, libuuid, fuse }:

stdenv.mkDerivation rec {
  name = "blobfuse-${version}";
  version = "1.0.1-RC-Preview";

  src = fetchFromGitHub {
    owner  = "Azure";
    repo   = "azure-storage-fuse";
    rev    = "v${version}";
    sha256 = "143rxgfmprir4a7frrv8llkv61jxzq50w2v8wn32vx6gl6vci1zs";
  };

  buildInputs = [ curl gnutls libgcrypt libuuid fuse ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "Mount an Azure Blob storage as filesystem through FUSE";
    license = licenses.mit;
    maintainers = with maintainers; [ jbgi ];
    platforms = platforms.linux;
  };
}
