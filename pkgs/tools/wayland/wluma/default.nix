{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rustPlatform
, vulkan-loader
, pkg-config
, udev
, v4l-utils
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "wluma";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    rev = version;
    sha256 = "sha256-H5ohAawHTvZoFq4t5dUgP4Tr5qNyXEP4SG738Bo8mxc=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    udev
    v4l-utils.lib
  ];

  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";

  # Works around the issue with rust-bindgen and the Nix gcc wrapper:
  # https://hoverbear.org/blog/rust-bindgen-in-nix/
  preBuild = ''
    export BINDGEN_EXTRA_CLANG_ARGS="$(< ${stdenv.cc}/nix-support/libc-cflags) \
    $(< ${stdenv.cc}/nix-support/cc-cflags) \
    -isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion llvmPackages.clang}/include \
    -idirafter ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${lib.getVersion stdenv.cc.cc}/include \
    -idirafter ${v4l-utils.dev}/include"
  '';

  postInstall = ''
    wrapProgram $out/bin/wluma \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ vulkan-loader ]}"
  '';

  cargoSha256 = "sha256-xLmDDy6qKXo0mLW3R4hQfZssg6lpo0G018TonF1uS14=";

  meta = with lib; {
    description = "Automatic brightness adjustment based on screen contents and ALS";
    homepage = "https://github.com/maximbaz/wluma";
    license = licenses.isc;
    maintainers = with maintainers; [ yevhenshymotiuk ];
    platforms = platforms.linux;
  };
}
