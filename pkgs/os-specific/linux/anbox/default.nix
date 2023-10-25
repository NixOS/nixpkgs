{ lib, stdenv, fetchFromGitHub, fetchurl
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
, writeScript
}:

let

  dbus-service = writeText "org.anbox.service" ''
    [D-BUS Service]
    Name=org.anbox
    Exec=@out@/libexec/anbox-session-manager
  '';

  anbox-application-manager = writeScript "anbox-application-manager" ''
    #!${runtimeShell}

    ${systemd}/bin/busctl --user call \
        org.freedesktop.DBus \
        /org/freedesktop/DBus \
        org.freedesktop.DBus \
        StartServiceByName "su" org.anbox 0

    @out@/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
  '';

in

stdenv.mkDerivation rec {
  pname = "anbox";
  version = "unstable-2021-10-20";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "84f0268012cbe322ad858d76613f4182074510ac";
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
    maintainers = with maintainers; [ edwtjo ];
    platforms = [ "armv7l-linux" "aarch64-linux" "x86_64-linux" ];
  };

}
