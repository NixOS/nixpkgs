{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

# build
, cmake
, ninja
, pkg-config

# runtime
, boost
, lame
, libogg
, libvorbis
, flac
, kaldi
, libopus
, openfst
, opusfile
, bzip2
, opencore-amr
, sox
, xz
, zlib

# kaldi build
, openblas
, icu

# propagates
, torch
, pybind11

# tests
}:

let
  pname = "torchaudio";
  version = "0.13.0";
in

buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    rev = "refs/tags/v${version}";
    hash = "sha256-66WwbxLGvJ1hEuEUKgpxGIniFAGy7nugrMd5WzIZ5/I=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/use-system-libs.diff?h=python-torchaudio";
      hash = "sha256-am1Un/y54/pH+JDxedvkHZWy7ThvTlMVsGlVZwWSgL0=";
    })
  ];

  postPatch = ''
    (cd third_party/kaldi/submodule && patch -p1 < ../kaldi.patch)

    for dep in sox bzip2 lzma zlib; do
      echo "add_library($dep INTERFACE)" > third_party/$dep/CMakeLists.txt
    done

    sed -i '/_fetch_third_party_libraries()$/d' setup.py
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    pybind11
  ];

  preConfigure = ''
    export cmakeBuilDir=$(pwd)
  '';

  cmakeFlags = [
    "-DKALDI_INCLUDE_DIRS=${lib.getDev kaldi}/include"
  ];


  buildInputs = [
    boost
    bzip2
    lame
    libogg
    flac
    libvorbis
    libopus
    openfst
    opusfile
    opencore-amr
    pybind11
    torch
    sox
    xz
    zlib
  ];

  preBuild = ''
    cd ..
  '';

  propagatedBuildInputs = [
    torch
  ];

  meta = with lib; {
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    description = "Data manipulation and transformation for audio signal processing, powered by PyTorch";
    homepage = "https://github.com/pytorch/audio";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
