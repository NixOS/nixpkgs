{ lib, stdenv, rustPlatform, fetchFromGitLab, libcap_ng, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
<<<<<<< HEAD
  version = "1.8.0";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-tbM2JWoub789s3YanT/lqCKl6JkY+FahSYb+lHvF7W8=";
  };

  cargoHash = "sha256-l2rWR9HAXTuNEarj2hWaZxpTdUNGoCnNfsZs8Y+of+s=";
=======
    sha256 = "jxo6qQLIhwT6cqhYWx+5GEnuS9E7O2u82QrzxabjcOs=";
  };

  cargoHash = "sha256-1wDlYQXRJSkXyQU7H+mQWtsLSpX7i7SdmFYLjyRWfx8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  LIBCAPNG_LIB_PATH = "${lib.getLib libcap_ng}/lib";
  LIBCAPNG_LINK_TYPE =
    if stdenv.hostPlatform.isStatic then "static" else "dylib";

  buildInputs = [ libcap_ng libseccomp ];

  meta = with lib; {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    description = "vhost-user virtio-fs device backend written in Rust";
<<<<<<< HEAD
    maintainers = with maintainers; [ qyliss astro ];
=======
    maintainers = with maintainers; [ qyliss ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
    license = with licenses; [ asl20 /* and */ bsd3 ];
  };
}
