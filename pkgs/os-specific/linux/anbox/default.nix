{ lib, stdenv, fetchFromGitHub, fetchurl
<<<<<<< HEAD
, callPackage
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, writeShellScript
, nixosTests
=======
, writeScript
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let

  dbus-service = writeText "org.anbox.service" ''
    [D-BUS Service]
    Name=org.anbox
    Exec=@out@/libexec/anbox-session-manager
  '';

<<<<<<< HEAD
  anbox-application-manager = writeShellScript "anbox-application-manager" ''
    exec @out@/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
=======
  anbox-application-manager = writeScript "anbox-application-manager" ''
    #!${runtimeShell}

    ${systemd}/bin/busctl --user call \
        org.freedesktop.DBus \
        /org/freedesktop/DBus \
        org.freedesktop.DBus \
        StartServiceByName "su" org.anbox 0

    @out@/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

in

stdenv.mkDerivation rec {
  pname = "anbox";
<<<<<<< HEAD
  version = "unstable-2023-02-03";
=======
  version = "unstable-2021-10-20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
<<<<<<< HEAD
    rev = "ddf4c57ebbe3a2e46099087570898ab5c1e1f279";
=======
    rev = "84f0268012cbe322ad858d76613f4182074510ac";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "sha256-QXWhatewiUDQ93cH1UZsYgbjUxpgB1ajtGFYZnKmabc=";
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

  # Flag needed by GCC 12 but unrecognized by GCC 9 (aarch64-linux default now)
  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (with stdenv; cc.isGNU && lib.versionAtLeast cc.version "12") [
    "-Wno-error=mismatched-new-delete"
  ]);

<<<<<<< HEAD
  prePatch = ''
=======
  patchPhase = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
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
=======
  postInstall = ''
    wrapProgram $out/bin/anbox \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    chmod +x $out/bin/anbox-application-manager
  '';

  passthru.tests = { inherit (nixosTests) anbox; };

  passthru.image = callPackage ./postmarketos-image.nix { };
  passthru.postmarketos-image = callPackage ./anbox-image.nix { };
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://anbox.io";
    description = "Android in a box";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = [ "armv7l-linux" "aarch64-linux" "x86_64-linux" ];
  };

}
