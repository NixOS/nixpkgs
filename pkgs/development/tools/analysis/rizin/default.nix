{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, libusb-compat-0_1
, readline
, libewf
, perl
, zlib
, openssl
, libuv
, file
, libzip
, lz4
, xxHash
, meson
, cmake
, ninja
, capstone
, tree-sitter
, python3
}:

stdenv.mkDerivation rec {
  pname = "rizin";
  version = "0.3.4";

  src = fetchurl {
    url = "https://github.com/rizinorg/rizin/releases/download/v${version}/rizin-src-v${version}.tar.xz";
    sha256 = "sha256-7qSbOWOHwJ0ZcFqrAqYXzbFWgvymfxAf8rJ+75SnEOk=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-36039.patch";
      url = "https://github.com/rizinorg/rizin/commit/52361f4f55107968820b1f3561c2ea7c451aed9d.patch";
      sha256 = "sha256-rox4vKfRcS3YKPP55VxmEiZ8KezLV53SK1QHE4Bc8g0=";
    })
    (fetchpatch {
      name = "CVE-2022-36040.patch";
      url = "https://github.com/rizinorg/rizin/commit/bfb5f751e6fc720b61829aab84eb3749cd8f696a.patch";
      sha256 = "sha256-xzMTSsHumN8FaIsWmBBIayCafvQXUJ0jPVQvOCodyRE=";
    })
    (fetchpatch {
      name = "CVE-2022-36041.patch";
      url = "https://github.com/rizinorg/rizin/commit/eeaf7c6a6fc64516fee82a4f0b8fbc1141e03d50.patch";
      sha256 = "sha256-MA2XmOuK91w1U6eWiHx8qhYB+13zdohMe8YmkdXN27g=";
    })
    (fetchpatch {
      name = "CVE-2022-36043.patch";
      url = "https://github.com/rizinorg/rizin/commit/9819f69ecfa02d5f0c3886df46c85df09a51db80.patch";
      sha256 = "sha256-u3CU5amtd5DRK7sg8Thp7wdg5SrcCFisdxRYFLdb7Zw=";
    })
    (fetchpatch {
      name = "CVE-2022-36044.part-1.patch";
      url = "https://github.com/rizinorg/rizin/commit/0f8e58bce910d7bcf4474f25277295c397e2fa7b.patch";
      sha256 = "sha256-o11UwH34Ew6EnksY5YLoFcZDeW8iYkznLpUW92tcX40=";
    })
    (fetchpatch {
      name = "CVE-2022-36044.part-2.patch";
      url = "https://github.com/rizinorg/rizin/commit/b9443604d5555cd02b1ca43c6fc0ec4896a73982.patch";
      sha256 = "sha256-mkPEmw6oGv1Tuo1mXT44gEuDHQ59anQuYzFkm7z/o7w=";
    })
  ];

  mesonFlags = [
    "-Duse_sys_capstone=enabled"
    "-Duse_sys_magic=enabled"
    "-Duse_sys_libzip=enabled"
    "-Duse_sys_zlib=enabled"
    "-Duse_sys_xxhash=enabled"
    "-Duse_sys_lz4=enabled"
    "-Duse_sys_openssl=enabled"
    "-Duse_sys_tree_sitter=enabled"
  ];

  nativeBuildInputs = [ pkg-config meson ninja cmake (python3.withPackages (ps: [ ps.setuptools ])) ];

  # meson's find_library seems to not use our compiler wrapper if static parameter
  # is either true/false... We work around by also providing LIBRARY_PATH
  preConfigure = ''
    LIBRARY_PATH=""
    for b in ${toString (map lib.getLib buildInputs)}; do
      if [[ -d "$b/lib" ]]; then
        LIBRARY_PATH="$b/lib''${LIBRARY_PATH:+:}$LIBRARY_PATH"
      fi
    done
    export LIBRARY_PATH
  '';

  buildInputs = [
    file
    libzip
    capstone
    readline
    libusb-compat-0_1
    libewf
    perl
    zlib
    lz4
    openssl
    libuv
    tree-sitter
    xxHash
  ];

  meta = {
    description = "UNIX-like reverse engineering framework and command-line toolset.";
    homepage = "https://rizin.re/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin makefu mic92 ];
    platforms = with lib.platforms; linux;
  };
}
