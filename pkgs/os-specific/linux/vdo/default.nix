{ lib, stdenv
, fetchFromGitHub
, installShellFiles
, libuuid
, lvm2_dmeventd  # <libdevmapper-event.h>
, zlib
, python3
}:

stdenv.mkDerivation rec {
  pname = "vdo";
<<<<<<< HEAD
  version = "8.2.2.2";  # bump this version with kvdo
=======
  version = "8.2.0.2";  # kvdo uses this!
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dm-vdo";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-+2w9jzJemI2xr+i/Jd5TIBZ/o8Zv+Ett0fbJbkOD7KI=";
=======
    hash = "sha256-IP/nL4jQ+rIWuUxXUiBtlIKTMZCNelvxgTfTcaB1it0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    libuuid
    lvm2_dmeventd
    zlib
    python3.pkgs.wrapPython
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
  ];

  pythonPath = propagatedBuildInputs;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "INSTALLOWNER="
    # all of these paths are relative to DESTDIR and have defaults that don't work for us
    "bindir=/bin"
    "defaultdocdir=/share/doc"
    "mandir=/share/man"
    "python3_sitelib=${python3.sitePackages}"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    installShellCompletion --bash $out/bash_completion.d/*
    rm -r $out/bash_completion.d

    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "https://github.com/dm-vdo/vdo";
    description = "A set of userspace tools for managing pools of deduplicated and/or compressed block storage";
<<<<<<< HEAD
    # platforms are defined in https://github.com/dm-vdo/vdo/blob/master/utils/uds/atomicDefs.h
    platforms = [ "x86_64-linux" "aarch64-linux" "s390-linux" "powerpc64-linux" "powerpc64le-linux" ];
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ ajs124 ];
  };
}
