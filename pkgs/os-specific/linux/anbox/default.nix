{ lib, stdenv, fetchFromGitHub, fetchurl
, fetchpatch
, cmake, pkg-config, dbus, makeWrapper
, boost
, elfutils # for libdw
, git
, glib
, glm
, gtest
, libbfd
, libcap
, libdwarf
, libGL
, libglvnd
, lxc
, mesa
, properties-cpp
, protobuf
, protobufc
, python3
, runtimeShell
, SDL2
, SDL2_image
, systemd
, writeText
, writeShellScript
}:

let

  dbus-service = writeText "org.anbox.service" ''
    [D-BUS Service]
    Name=org.anbox
    Exec=@out@/libexec/anbox-session-manager
  '';

  anbox-application-manager = writeShellScript "anbox-application-manager" ''
    exec @out@/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
  '';

in

stdenv.mkDerivation rec {
  pname = "anbox";
  version = "unstable-2021-05-26";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "ad377ff25354d68b76e2b8da24a404850f8514c6";
    sha256 = "1bj07ixwbkli4ycjh41mnqdbsjz9haiwg2nhf9anbi29z1d0819w";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    boost
    dbus
    elfutils # libdw
    glib
    glm
    gtest
    libbfd
    libcap
    libdwarf
    libGL
    lxc
    mesa
    properties-cpp
    protobuf protobufc
    python3
    SDL2 SDL2_image
    systemd
  ];

  prePatch = ''
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

  patches = [
    # Fixes compatibility with lxc 4
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/anbox/lxc4.patch?id=64243590a16aee8d4e72061886fc1b15256492c3";
      sha256 = "1da5xyzyjza1g2q9nbxb4p3njj2sf3q71vkpvmmdphia5qnb0gk5";
    })
    # Wait 10× more time when starting
    # Not *strictly* needed, but helps a lot on slower hardware
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/anbox/give-more-time-to-start.patch?id=058b56d4b332ef3379551b343bf31e0f2004321a";
      sha256 = "0iiz3c7fgfgl0dvx8sf5hv7a961xqnihwpz6j8r0ib9v8piwxh9a";
    })
    # Ensures generated desktop files work on store path change
    ./0001-NixOS-Use-anbox-from-PATH-in-desktop-files.patch
    # Provide window icons
    (fetchpatch {
      url = "https://github.com/samueldr/anbox/commit/2387f4fcffc0e19e52e58fb6f8264fbe87aafe4d.patch";
      sha256 = "12lmr0kxw1n68g3abh1ak5awmpczfh75c26f53jc8qpvdvv1ywha";
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/anbox \
      --set SDL_VIDEO_X11_WMCLASS "anbox" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libGL libglvnd]} \
      --prefix PATH : ${git}/bin

    mkdir -p $out/share/dbus-1/services
    substitute ${dbus-service} $out/share/dbus-1/services/org.anbox.service \
      --subst-var out

    mkdir $out/libexec
    makeWrapper $out/bin/anbox $out/libexec/anbox-session-manager \
      --add-flags session-manager

    substitute ${anbox-application-manager} $out/bin/anbox-application-manager \
      --subst-var out
    chmod +x $out/bin/anbox-application-manager
  '';

  passthru.image = let
    imgroot = "https://build.anbox.io/android-images";
  in
    {
      armv7l-linux = fetchurl {
        url = imgroot + "/2017/06/12/android_1_armhf.img";
        sha256 = "1za4q6vnj8wgphcqpvyq1r8jg6khz7v6b7h6ws1qkd5ljangf1w5";
      };
      aarch64-linux = fetchurl {
        url = imgroot + "/2017/08/04/android_1_arm64.img";
        sha256 = "02yvgpx7n0w0ya64y5c7bdxilaiqj9z3s682l5s54vzfnm5a2bg5";
      };
      x86_64-linux = fetchurl {
        url = imgroot + "/2018/07/19/android_amd64.img";
        sha256 = "1jlcda4q20w30cm9ikm6bjq01p547nigik1dz7m4v0aps4rws13b";
      };
    }.${stdenv.system} or null;

  meta = with lib; {
    homepage = "https://anbox.io";
    description = "Android in a box";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo samueldr ];
    platforms = [ "armv7l-linux" "aarch64-linux" "x86_64-linux" ];
  };

}
