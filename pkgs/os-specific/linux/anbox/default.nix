{ stdenv, lib, fetchFromGitHub, fetchurl
, cmake, pkgconfig, dbus, makeWrapper
, googletest
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
  version = "2018-10-08";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "c8a760c1f985e09df0a2983ae9207f644f3f71fe";
    sha256 = "1ypxvniq0wzw9lnqbhlyx03x8c0sbzlzi6y7q3k3mza2i6abl8vc";
  };

  buildInputs = [
    cmake pkgconfig dbus boost libcap googletest systemd mesa glib
    SDL2 SDL2_image protobuf protobufc properties-cpp lxc python
    makeWrapper libGL
  ];

  patchPhase =
  let gtsrc = googletest
            + "/share/googletest-" + lib.getVersion googletest;
  in ''
    patchShebangs scripts
    # Fix googletest references
    sed -i \
      -e "s,/usr/src/googletest,${gtsrc},g" \
      cmake/FindGMock.cmake
    # Disable testing for now
    sed -i \
      '/^add_subdirectory(tests)/d' \
      CMakeLists.txt
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
