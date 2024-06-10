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
  version = "8.2.2.2";  # bump this version with kvdo

  src = fetchFromGitHub {
    owner = "dm-vdo";
    repo = pname;
    rev = version;
    hash = "sha256-+2w9jzJemI2xr+i/Jd5TIBZ/o8Zv+Ett0fbJbkOD7KI=";
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
    description = "Set of userspace tools for managing pools of deduplicated and/or compressed block storage";
    # platforms are defined in https://github.com/dm-vdo/vdo/blob/master/utils/uds/atomicDefs.h
    platforms = [ "x86_64-linux" "aarch64-linux" "s390-linux" "powerpc64-linux" "powerpc64le-linux" ];
    license = with licenses; [ gpl2Plus ];
    maintainers = teams.helsinki-systems.members;
  };
}
