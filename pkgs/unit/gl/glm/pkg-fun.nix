{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  version = "0.9.9.8";
  pname = "glm";

  src = fetchFromGitHub {
    owner = "g-truc";
    repo = pname;
    rev = version;
    sha256 = "sha256-F//+3L5Ozrw6s7t4LrcUmO7sN30ZSESdrPAYX57zgr8=";
  };

  # https://github.com/g-truc/glm/pull/1055
  # Fix more implicit-int-float-conversion warnings
  # (https://github.com/g-truc/glm/pull/986 wasn't enough, and -Werror is used)
  patches = [(fetchpatch {
    url = "https://github.com/kraj/glm/commit/bd9b5060bc3b9581090d44f15b4e236566ea86a6.patch";
    sha256 = "sha256-QO4o/wV564kJimBcEyr9TWzREEnRJ1n0j0HPojN4pkI=";
  })];

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ cmake ];

  NIX_CFLAGS_COMPILE =
    lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") [
      "-fno-ipa-modref" # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102823
    ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
    "-DBUILD_STATIC_LIBS=OFF"
    "-DGLM_TEST_ENABLE=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    # Install header-only library
    mkdir -p $out/include
    cp -rv ../glm $out/include
    rm $out/include/glm/CMakeLists.txt
    rm $out/include/glm/detail/*.cpp

    # Install CMake files
    mkdir -p $out/lib
    cp -rv ../cmake $out/lib
    substituteInPlace $out/lib/cmake/glm/glmConfig.cmake \
        --replace 'GLM_INCLUDE_DIRS ''${_IMPORT_PREFIX}' "GLM_INCLUDE_DIRS $out/include"

    # Install pkg-config file
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./glm.pc.in} $out/lib/pkgconfig/glm.pc

    # Install docs
    mkdir -p $doc/share/doc/glm
    cp -rv ../doc/api $doc/share/doc/glm/html
    cp -v ../doc/manual.pdf $doc/share/doc/glm

    runHook postInstall
  '';

  meta = with lib; {
    description = "OpenGL Mathematics library for C++";
    longDescription = ''
      OpenGL Mathematics (GLM) is a header only C++ mathematics library for
      graphics software based on the OpenGL Shading Language (GLSL)
      specification and released under the MIT license.
    '';
    homepage = "https://github.com/g-truc/glm";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ smancill ];
  };
}

