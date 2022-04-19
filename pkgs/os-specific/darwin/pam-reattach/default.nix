{ fetchgit, stdenv, lib, darwin, cmake, ... }:

stdenv.mkDerivation rec {
  name = "pam-reattach";
  version = "1.2";

  src = fetchgit {
    url = "https://github.com/fabianishere/pam_reattach";
    rev = "24d5be4fbd27df4a3792511978fb37e0649d3527";
    sha256 = "sha256-MhOy2GcvLGfrWM7xE5N9zD5Q7pYhiMdFPlBbfsF8HyY=";
  };

  buildInputs = [ cmake ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.MacOSX-SDK ;

  configurePhase = ''
    CMAKE_LIBRARY_PATH "${darwin.apple_sdk.MacOSX-SDK}/usr/lib" cmake \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_PAM=true \
      -DENABLE_CLI=true \
      .
  '';

  meta = with lib; {
    description = "Reattach to the user's GUI session on macOS during authentication (for Touch ID support in tmux)";
    homepage = "https://github.com/fabianishere/pam_reattach";
    licenses = licenses.mit;
    maintainers = with maintainers; [ congee ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
