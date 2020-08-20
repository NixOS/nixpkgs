{ stdenv, fetchgit
, meson, ninja, pkgconfig
, systemd, libxkbcommon, wayland, wayland-protocols
, pixman, mesa, libX11
, xwayland
, scdoc, buildDocs ? true
}:

stdenv.mkDerivation rec {
  pname = "sommelier";
  version = "2020-08-10-${builtins.substring 0 7 rev}";
  rev = "be4e16feb380360cabbb5d6199a09592ecaf4a42";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform2";
    inherit rev;
    sha256 = "rl1O/8YggO5UIKKASiZjtH18QGjza8ea3VGE4Hnefug=";
  };
  setSourceRoot="sourceRoot=$(echo platform2-*/vm_tools/sommelier)";

  nativeBuildInputs = [ pkgconfig meson ninja ]
    ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    systemd libxkbcommon wayland wayland-protocols
    pixman mesa libX11
  ];

  mesonFlags = [
    "-Dxwayland_path=${xwayland}/bin/Xwayland"
    "-Dpeer_cmd_prefix=${placeholder "out"}/bin/sommelier"
    "-Dxwayland_gl_driver_path=/run/opengl-driver/lib/dri"
    "-Dxwayland_shm_driver=noop"
    "-Dshm_driver=noop"
  ];

  NIX_CFLAGS_COMPILE = ["-DVIRTWL_DEVICE=NULL"];

  postPatch = ''
    mkdir linux
    cp ${./virtwl.h} linux/virtwl.h
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Nested Wayland compositor with support for X11 forwarding";
    homepage    = "https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vm_tools/sommelier";
    license     = licenses.bsd2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ offline ];
  };
}

