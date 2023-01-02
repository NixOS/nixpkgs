{ lib
, stdenv
, fetchFromGitHub
, cmake
, cpm-cmake
, git
, cacert
, boost179
, fmt_8
, icu
, libarchive
, libgit2
, lz4
, ninja
, openssl_3
, spdlog
}:

let
  git2Cpp = fetchFromGitHub {
    owner = "ken-matsui";
    repo = "git2-cpp";
    rev = "v0.1.0-alpha.1";
    sha256 = "sha256-Ub0wrBK5oMfWGv+kpq/W1PN3yzpcfg+XWRFF/lV9VCY=";
  };

  glob = fetchFromGitHub {
    owner = "p-ranav";
    repo = "glob";
    rev = "v0.0.1";
    sha256 = "sha256-2y+a7YFBiYX8wbwCCWw1Cm+SFoXGB3ZxLPi/QdZhcdw=";
  };

  packageProjectCMake = fetchFromGitHub {
    owner = "TheLartians";
    repo = "PackageProject.cmake";
    rev = "v1.3";
    sha256 = "sha256-ZktftDrPo+JhBt0XKJekv0cyxIagvcgMcXZOBd4RtKs=";
  };

  mitamaCppResult = fetchFromGitHub {
    owner = "LoliGothick";
    repo = "mitama-cpp-result";
    rev = "v9.3.0";
    sha256 = "sha256-CWYVPpmPIZZTsqXKh+Ft3SlQ4C9yjUof1mJ8Acn5kmM=";
  };

  structopt = fetchFromGitHub {
    owner = "p-ranav";
    repo = "structopt";
    rev = "e9722d3c2b52cf751ebc1911b93d9649c4e365cc";
    sha256 = "sha256-jIfKUyY2QQ2/donywwlz65PY8u7xODGoG6SlNtUhwkg=";
  };

  toml11 = fetchFromGitHub {
    owner = "ToruNiina";
    repo = "toml11";
    rev = "9086b1114f39a8fb10d08ca704771c2f9f247d02";
    sha256 = "sha256-fHUElHO4ckNQq7Q88GdbHGxfaAvWoWtGB0eD9y2MnLo=";
  };
in
stdenv.mkDerivation rec {
  pname = "poac";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "poacpm";
    repo = pname;
    rev = version;
    sha256 = "sha256-jXYPeI/rVuTr7OYV5sMgNr+U1OfN0XZtun6mihtlErY=";
  };

  preConfigure = ''
    mkdir -p ${placeholder "out"}/share/cpm
    cp ${cpm-cmake}/share/cpm/CPM.cmake ${placeholder "out"}/share/cpm/CPM_0.35.1.cmake
  '';

  cmakeFlags = [
    "-DCPM_USE_LOCAL_PACKAGES=ON"
    "-DCPM_SOURCE_CACHE=${placeholder "out"}/share"
    "-DFETCHCONTENT_SOURCE_DIR_FMT=${fmt_8}"
    "-DFETCHCONTENT_SOURCE_DIR_GIT2-CPP=${git2Cpp}"
    "-DFETCHCONTENT_SOURCE_DIR_GLOB=${glob}"
    "-DFETCHCONTENT_SOURCE_DIR_PACKAGEPROJECT.CMAKE=${packageProjectCMake}"
    "-DFETCHCONTENT_SOURCE_DIR_MITAMA-CPP-RESULT=${mitamaCppResult}"
    "-DFETCHCONTENT_SOURCE_DIR_NINJA=${ninja.src}"
    "-DFETCHCONTENT_SOURCE_DIR_STRUCTOPT=${structopt}"
    "-DFETCHCONTENT_SOURCE_DIR_TOML11=${toml11}"
  ];

  nativeBuildInputs = [ cmake git cacert ];
  buildInputs = [
    (boost179.override {
      enableShared = stdenv.isDarwin;
      enableStatic = !stdenv.isDarwin;
    })
    fmt_8
    git2Cpp
    glob
    packageProjectCMake
    mitamaCppResult
    ninja
    structopt
    toml11
    icu
    libarchive
    libgit2
    lz4
    openssl_3
    spdlog
  ];

  meta = with lib; {
    homepage = "https://poac.pm";
    description = "Package Manager for C++";
    license = licenses.asl20;
    maintainers = with maintainers; [ ken-matsui ];
    platforms = platforms.unix;
    # https://github.com/NixOS/nixpkgs/pull/189712#issuecomment-1237791234
    broken = (stdenv.isLinux && stdenv.isAarch64)
    # error: excess elements in scalar initializer on std::aligned_alloc
          || (stdenv.isDarwin && stdenv.isx86_64);
  };
}
