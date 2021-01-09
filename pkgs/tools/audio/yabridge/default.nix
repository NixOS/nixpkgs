{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wine
, boost
, libxcb
}:

let
  # Derived from subprojects/bitsery.wrap
  bitsery = rec {
    version = "5.2.0";
    src = fetchFromGitHub {
      owner = "fraillt";
      repo = "bitsery";
      rev = "v${version}";
      sha256 = "132b0n0xlpcv97l6bhk9n57hg95pkhwqzvr9jkv57nmggn76s5q7";
    };
  };

  # Derived from subprojects/function2.wrap
  function2 = rec {
    version = "4.1.0";
    src = fetchFromGitHub {
      owner = "Naios";
      repo = "function2";
      rev = version;
      sha256 = "0abrz2as62725g212qswi35nsdlf5wrhcz78hm2qidbgqr9rkir5";
    };
  };

  # Derived from subprojects/tomlplusplus.wrap
  tomlplusplus = rec {
    version = "2.1.0";
    src = fetchFromGitHub {
      owner = "marzer";
      repo = "tomlplusplus";
      rev = "v${version}";
      sha256 = "0fspinnpyk1c9ay0h3wl8d4bbm6aswlypnrw2c7pk2i4mh981b4b";
    };
  };
in stdenv.mkDerivation rec {
  pname = "yabridge";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = pname;
    rev = version;
    sha256 = "0fg3r12hk8xm4698pbw9rjzcgrmibc2l3651pj96w0dzn6kyxi2g";
  };

  # Unpack subproject sources
  postUnpack = ''(
    cd "$sourceRoot/subprojects"
    cp -R --no-preserve=mode,ownership ${bitsery.src} bitsery-${bitsery.version}
    tar -xf bitsery-patch-${bitsery.version}.tar.xz
    cp -R --no-preserve=mode,ownership ${function2.src} function2-${function2.version}
    tar -xf function2-patch-${function2.version}.tar.xz
    cp -R --no-preserve=mode,ownership ${tomlplusplus.src} tomlplusplus
  )'';

  patches = [
    ./include-mutex.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wine
  ];

  buildInputs = [
    boost
    libxcb
  ];

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";

  mesonFlags = [
    "--cross-file" "cross-wine.conf"

    # Requires CMake and is unnecessary
    "-Dtomlplusplus:GENERATE_CMAKE_CONFIG=disabled"

    # tomlplusplus examples and tests don't build with winegcc
    "-Dtomlplusplus:BUILD_EXAMPLES=disabled"
    "-Dtomlplusplus:BUILD_TESTS=disabled"
  ];

  installPhase = ''
    mkdir -p "$out/bin" "$out/lib"
    cp yabridge-group.exe{,.so} "$out/bin"
    cp yabridge-host.exe{,.so} "$out/bin"
    cp libyabridge.so "$out/lib"
  '';

  meta = with lib; {
    description = "Yet Another VST bridge, run Windows VST2 plugins under Linux";
    homepage = "https://github.com/robbert-vdh/yabridge";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
    platforms = [ "x86_64-linux" ];
  };
}
