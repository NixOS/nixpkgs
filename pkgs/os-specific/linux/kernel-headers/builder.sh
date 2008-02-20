source $stdenv/setup

patchPhase="sed -i '/scsi/d' include/Kbuild"

buildPhase="make mrproper headers_check";

installPhase="make INSTALL_HDR_PATH=$out headers_install"

genericBuild
