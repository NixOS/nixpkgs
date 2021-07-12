{ pname, version, src
, stdenv
, lib
, cmake
, pkg-config
, openal
, glew
, glfw
, mpg123
, librw
, waylandSupport ? false, xorg
, withLibsndfile ? true, libsndfile
, withOpus ? false, opusfile, libogg
}:

let
  project = lib.toUpper pname;

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openal
    glew
    glfw
    mpg123
    librw
  ] ++ lib.optionals (!waylandSupport && !stdenv.isDarwin) (with xorg; [
    libX11
    libXrandr
  ]) ++ lib.optional withLibsndfile libsndfile
  ++ lib.optionals withOpus [
    opusfile
    libogg
  ];

  cmakeFlags = [
    "-D${project}_VENDORED_LIBRW=OFF"
    "-D${project}_INSTALL=ON"
  ] ++ lib.optional withLibsndfile "-D${project}_WITH_LIBSNDFILE=ON"
  ++ lib.optional withOpus "-D${project}_WITH_OPUS=ON";

  postPatch = ''
    sed -i 's,DESTINATION ".",DESTINATION "share/games/${pname}/gamefiles",' CMakeLists.txt
    sed -i 's,DESTINATION ".",DESTINATION "bin",' src/CMakeLists.txt
  '' + lib.optionalString waylandSupport ''
    sed -i '/#define GET_KEYBOARD_INPUT_FROM_X11/d' src/skel/glfw/glfw.cpp
  '' + lib.optionalString (!waylandSupport && !stdenv.isDarwin) ''
    cat << EOF >> src/CMakeLists.txt
      find_package(X11 REQUIRED)
      target_include_directories(\''${EXECUTABLE} PRIVATE \''${X11_INCLUDE_DIR})
      target_link_libraries(\''${EXECUTABLE} PRIVATE \''${X11_LIBRARIES})
    EOF
  '';

  meta = with lib; {
    description = "An open-source project reverse-engineering Grand Theft Auto";
    homepage = "https://github.com/GTAmodding/re3";
    license = licenses.free;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
