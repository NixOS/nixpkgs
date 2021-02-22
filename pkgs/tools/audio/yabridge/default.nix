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

  # Derived from vst3.wrap
  vst3 = rec {
    version = "e2fbb41f28a4b311f2fc7d28e9b4330eec1802b6";
    src = fetchFromGitHub {
      owner = "robbert-vdh";
      repo = "vst3sdk";
      rev = version;
      fetchSubmodules = true;
      sha256 = "1fqpylkbljifwdw2z75agc0yxnhmv4b09fxs3rvlw1qmm5mwx0p2";
    };
  };
in stdenv.mkDerivation rec {
  pname = "yabridge";
  version = "3.0.0";

  # NOTE: Also update yabridgectl's cargoSha256 when this is updated
  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = pname;
    rev = version;
    sha256 = "0ha7jhnkd2i49q5rz2hp7sq6hv19bir99x51hs6nvvcf16hlf2bp";
  };

  # Unpack subproject sources
  postUnpack = ''(
    cd "$sourceRoot/subprojects"
    cp -R --no-preserve=mode,ownership ${bitsery.src} bitsery-${bitsery.version}
    tar -xf bitsery-patch-${bitsery.version}.tar.xz
    cp -R --no-preserve=mode,ownership ${function2.src} function2-${function2.version}
    tar -xf function2-patch-${function2.version}.tar.xz
    cp -R --no-preserve=mode,ownership ${tomlplusplus.src} tomlplusplus
    cp -R --no-preserve=mode,ownership ${vst3.src} vst3
  )'';

  postPatch = ''
    patchShebangs .
  '';

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
    cp libyabridge-vst2.so "$out/lib"
    cp libyabridge-vst3.so "$out/lib"
  '';

  meta = with lib; {
    description = "Yet Another VST bridge, run Windows VST2 plugins under Linux";
    homepage = "https://github.com/robbert-vdh/yabridge";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
    platforms = [ "x86_64-linux" ];
  };
}
