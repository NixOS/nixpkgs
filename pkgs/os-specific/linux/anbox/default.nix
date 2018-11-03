{ stdenv, lib, fetchFromGitHub, fetchurl
, cmake, pkgconfig, dbus, makeWrapper
, gtest
, boost
, libcap
, systemd
, mesa
, libGL
, libglvnd
, glib
, git
, SDL2
, SDL2_image
, properties-cpp
, protobuf
, protobufc
, python
, lxc
}:

stdenv.mkDerivation rec {
  pname = "anbox";
  version = "2019-03-07";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "d521e282965462e82465045ab95d4ae1c4619685";
    sha256 = "1wfx4bsyxvrjl16dq5pqgial8rnnsnxzbak2ap0waddz847czxwz";
  };

  buildInputs = [
    cmake pkgconfig dbus boost libcap gtest systemd mesa glib
    SDL2 SDL2_image protobuf protobufc properties-cpp lxc python
    makeWrapper libGL
  ];

  patchPhase = ''
    patchShebangs scripts

    cat >cmake/FindGMock.cmake <<'EOF'
      add_library(gtest INTERFACE)
      target_include_directories(gtest INTERFACE ${gtest.dev}/include)
      target_link_libraries(gtest INTERFACE ${gtest}/lib/libgtest.so ''${CMAKE_THREAD_LIBS_INIT})
      add_dependencies(gtest GMock)

      add_library(gtest_main INTERFACE)
      target_include_directories(gtest_main INTERFACE ${gtest.dev}/include)
      target_link_libraries(gtest_main INTERFACE ${gtest}/lib/libgtest_main.so gtest)

      add_library(gmock INTERFACE)
      target_include_directories(gmock INTERFACE ${gtest.dev}/include)
      target_link_libraries(gmock INTERFACE ${gtest}/lib/libgmock.so gtest)

      add_library(gmock_main INTERFACE)
      target_include_directories(gmock_main INTERFACE ${gtest.dev}/include)
      target_link_libraries(gmock_main INTERFACE ${gtest}/lib/libgmock_main.so gmock gtest_main)

      set(GTEST_LIBRARIES gtest)
      set(GTEST_MAIN_LIBRARIES gtest_main)
      set(GMOCK_LIBRARIES gmock gmock_main)
      set(GTEST_BOTH_LIBRARIES ''${GTEST_LIBRARIES} ''${GTEST_MAIN_LIBRARIES})
    EOF
  '';

  postInstall = ''
    wrapProgram $out/bin/anbox \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [libGL libglvnd]} \
      --prefix PATH : ${git}/bin

    mkdir -p $out/share/dbus-1/services/
    cat <<END > $out/share/dbus-1/services/org.anbox.service
    [D-BUS Service]
    Name=org.anbox
    Exec=$out/libexec/anbox-session-manager
    END

    mkdir $out/libexec
    cat > $out/libexec/anbox-session-manager <<EOF
    #!${stdenv.shell}
    exec $out/bin/anbox session-manager
    EOF
    chmod +x $out/libexec/anbox-session-manager

    cat > $out/bin/anbox-application-manager <<EOF
    #!${stdenv.shell}
    ${systemd}/bin/busctl --user call \
      org.freedesktop.DBus \
      /org/freedesktop/DBus \
      org.freedesktop.DBus \
      StartServiceByName "su" org.anbox 0

    $out/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
    EOF
    chmod +x $out/bin/anbox-application-manager
  '';

  passthru.image = let
    imgroot = "https://build.anbox.io/android-images";
    arches = {
      armv7l-linux = {
        url = imgroot + "/2017/06/12/android_1_armhf.img";
        sha256 = "1za4q6vnj8wgphcqpvyq1r8jg6khz7v6b7h6ws1qkd5ljangf1w5";
      };
      aarch64-linux = {
        url = imgroot + "/2017/08/04/android_1_arm64.img";
        sha256 = "02yvgpx7n0w0ya64y5c7bdxilaiqj9z3s682l5s54vzfnm5a2bg5";
      };
      x86_64-linux = {
        url = imgroot + "/2018/07/19/android_amd64.img";
        sha256 = "1jlcda4q20w30cm9ikm6bjq01p547nigik1dz7m4v0aps4rws13b";
      };
    };
  in
  fetchurl {
    inherit (arches.${stdenv.system}) url sha256;
  };

  meta = with stdenv.lib; {
    homepage = https://anbox.io;
    description = "Android in a box.";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };

}
