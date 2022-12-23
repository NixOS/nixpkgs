{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, curl, gnutls, libgcrypt, libuuid, fuse, boost }:

let
  version = "1.3.7";
  src = fetchFromGitHub {
    owner  = "Azure";
    repo   = "azure-storage-fuse";
    rev    = "blobfuse-${version}-Linux";
    sha256 = "sha256-yihIuS4AG489U7eBi/p7H6S7Cg54kkQeNVCexxQZ60A=";
  };
  cpplite = stdenv.mkDerivation rec {
    pname = "cpplite";
    inherit version src;

    sourceRoot = "source/cpplite";
    patches = [ ./install-adls.patch ];

    cmakeFlags = [ "-DBUILD_ADLS=ON" "-DUSE_OPENSSL=OFF" ];

    buildInputs = [ curl libuuid gnutls ];
    nativeBuildInputs = [ cmake pkg-config ];
  };
in stdenv.mkDerivation rec {
  pname = "blobfuse";
  inherit version src;

  NIX_CFLAGS_COMPILE = [
    # Needed with GCC 12
    "-Wno-error=deprecated-declarations"
    "-Wno-error=catch-value"
  ];

  buildInputs = [ curl gnutls libgcrypt libuuid fuse boost cpplite ];
  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "Mount an Azure Blob storage as filesystem through FUSE";
    license = licenses.mit;
    maintainers = with maintainers; [ jbgi ];
    platforms = platforms.linux;
  };
}
