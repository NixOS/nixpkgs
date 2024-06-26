{
  fetchurl,
  fetchpatch,
  stdenv,
  systemd,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "unscd";
  version = "0.54";

  src = fetchurl {
    url = "https://busybox.net/~vda/unscd/nscd-${version}.c";
    sha256 = "0iv4iwgs3sjnqnwd7dpcw6s7i4ar9q89vgsms32clx14fdqjrqch";
  };

  unpackPhase = ''
    runHook preUnpack
    cp $src nscd.c
    chmod u+w nscd.c
    runHook postUnpack
  '';

  patches = [
    # Patches from Debian that have not (yet) been included upstream, but are useful to us
    (fetchpatch {
      url = "https://sources.debian.org/data/main/u/${pname}/${version}-1/debian/patches/change_invalidate_request_info_output";
      sha256 = "17whakazpisiq9nnw3zybaf7v3lqkww7n6jkx0igxv4z2r3mby6l";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/u/${pname}/${version}-1/debian/patches/support_large_numbers_in_config";
      sha256 = "0jrqb4cwclwirpqfb6cvnmiff3sm2jhxnjwxa7h0wx78sg0y3bpp";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/u/${pname}/${version}-1/debian/patches/no_debug_on_invalidate";
      sha256 = "0znwzb522zgikb0mm7awzpvvmy0wf5z7l3jgjlkdpgj0scxgz86w";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/u/${pname}/${version}-1/debian/patches/notify_systemd_about_successful_startup";
      sha256 = "1ipwmbfwm65yisy74nig9960vxpjx683l3skgxfgssfx1jb9z2mc";
    })

    # The original unscd would crash, because it is not allowed to create its
    # legacy socket at /var/run/.nscd_socket.
    # This socket is only required for very old glibc versions, but removing it
    # is currently non-trivial, so we just move it somewhere, where it is
    # allowed to be created. A patch has been submitted upstream to make this
    # hack unnecessary.
    # Also change /var/run to /run, since we shouldn't be using /var/run
    # anymore.
    # See also: http://lists.busybox.net/pipermail/busybox/2021-June/088866.html
    ./0001-adjust-socket-paths-for-nixos.patch
  ];

  buildInputs = [ systemd ];

  buildPhase = ''
    runHook preBuild
    gcc -Wall \
      -Wl,--sort-section -Wl,alignment \
      -Wl,--sort-common \
      -fomit-frame-pointer \
      -lsystemd \
      -o nscd nscd.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin nscd
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://busybox.net/~vda/unscd/";
    description = "Less buggy replacement for the glibc name service cache daemon";
    mainProgram = "nscd";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
