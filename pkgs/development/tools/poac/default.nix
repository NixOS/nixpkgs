{ lib
, stdenv
, fetchFromGitHub
, cmake
, cpm-cmake
, git
, git2-cpp
, cacert
, boost179
, icu
, libarchive
, libgit2
, lz4
, mitama-cpp-result
, ninja
, openssl_3
, package-project-cmake
, spdlog
}:

let
  glob = fetchFromGitHub {
    owner = "p-ranav";
    repo = "glob";
    rev = "v0.0.1";
    sha256 = "sha256-2y+a7YFBiYX8wbwCCWw1Cm+SFoXGB3ZxLPi/QdZhcdw=";
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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "poacpm";
    repo = pname;
    rev = version;
    sha256 = "sha256-JgGa7lomDvZG5HLxGJMALcezjnZprexJDTxyTUjLetg=";
  };

  preConfigure = ''
    mkdir -p ${placeholder "out"}/share/cpm
    cp ${cpm-cmake}/share/cpm/CPM.cmake ${placeholder "out"}/share/cpm/CPM_0.35.1.cmake
  '';

  cmakeFlags = [
    "-DPOAC_BUILD_TESTING=OFF"
    "-DCPM_SOURCE_CACHE=${placeholder "out"}/share"
    "-DFETCHCONTENT_SOURCE_DIR_GIT2-CPP=${git2-cpp.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GLOB=${glob}"
    "-DFETCHCONTENT_SOURCE_DIR_PACKAGEPROJECT.CMAKE=${package-project-cmake.src}"
    "-DFETCHCONTENT_SOURCE_DIR_MITAMA-CPP-RESULT=${mitama-cpp-result.src}"
    "-DFETCHCONTENT_SOURCE_DIR_NINJA=${ninja.src}"
    "-DFETCHCONTENT_SOURCE_DIR_STRUCTOPT=${structopt}"
    "-DFETCHCONTENT_SOURCE_DIR_TOML11=${toml11}"
  ];

  nativeBuildInputs = [ cmake git cacert ];
  buildInputs = [
    (boost179.override {
      enableShared = stdenv.hostPlatform.isDarwin;
      enableStatic = !stdenv.hostPlatform.isDarwin;
    })
    git2-cpp
    glob
    package-project-cmake
    mitama-cpp-result
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
    maintainers = [ ];
    platforms = platforms.unix;
    # error: call to 'format' is ambiguous
    broken = true; # last successful build 2023-12-31
  };
}
