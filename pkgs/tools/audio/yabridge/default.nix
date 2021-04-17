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
      hash = "sha256-Bxdtjn2v2lP2lCnvjzmct6QHT7FpwmXoSZtd2oEFS4w=";
    };
  };

  # Derived from subprojects/function2.wrap
  function2 = rec {
    version = "4.1.0";
    src = fetchFromGitHub {
      owner = "Naios";
      repo = "function2";
      rev = version;
      hash = "sha256-JceZU8ZvtYhFheh8BjMvjjZty4hcYxHEK+IIo5X4eSk=";
    };
  };

  # Derived from subprojects/tomlplusplus.wrap
  tomlplusplus = rec {
    version = "2.1.0";
    src = fetchFromGitHub {
      owner = "marzer";
      repo = "tomlplusplus";
      rev = "v${version}";
      hash = "sha256-i6yAEqwkinkPEzzb6ynXytS1SEOUDwi8SixMf62NVzs=";
    };
  };

  # Derived from vst3.wrap
  vst3 = rec {
    version = "3.7.2_build_28-patched";
    src = fetchFromGitHub {
      owner = "robbert-vdh";
      repo = "vst3sdk";
      rev = "v${version}";
      fetchSubmodules = true;
      sha256 = "sha256-39pvfcg4fvf7DAbAPzEHA1ja1LFL6r88nEwNYwaDC8w=";
    };
  };
in stdenv.mkDerivation rec {
  pname = "yabridge";
  version = "3.1.0";

  # NOTE: Also update yabridgectl's cargoHash when this is updated
  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = pname;
    rev = version;
    hash = "sha256-xvKjb+ql3WxnGHqcn3WnxunY5+s9f8Gt/n6EFSBrNdI=";
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
