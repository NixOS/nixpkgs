{ stdenv, pkgs, fetchurl, lib, version, url, sha256, ... }:
stdenv.mkDerivation {
  name = "aesmd";
  version = version;
  src = fetchurl {
    url = url;
    name = "aesmd.deb";
    sha256 = sha256;
  };

  buildCommand = ''
    set -euo pipefail
    ar x $src
    mkdir -p $out
    tar -xaf data.tar.xz -C $out

    AESM_PATH=$out/opt/intel/libsgx-enclave-common/aesm

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${lib.makeLibraryPath (with pkgs; [ stdenv.cc.cc.lib openssl protobuf3_0 ])}:$AESM_PATH \
      $AESM_PATH/aesm_service

    mv $out/lib/systemd/system/aesmd.service $out/lib/systemd/system/aesmd.service.orig
    cat $out/lib/systemd/system/aesmd.service.orig \
     | sed 's:Type=forking:Type=simple:' \
     | sed '/LD_LIBRARY_PATH=/d' \
     | sed "s:ExecStartPre=/bin/mkdir -p /var/opt/aesmd/\n::" \
     | sed "s:ExecStartPre=/bin/chmod 0755 /var/run/aesmd/:ExecStartPre=/bin/chmod 0755 /var/run/aesmd/\nExecStartPre=/bin/mkdir -p /var/opt/aesmd/:" \
     | sed "/Type=simple/a Environment=LD_LIBRARY_PATH=/opt/intel/libsgx-enclave-common/aesm:${lib.makeLibraryPath [ pkgs.openssl pkgs.protobuf3_0 pkgs.curl ]}" \
     | sed "s:aesm/aesm_service:aesm/aesm_service --no-daemon:" \
     | sed "s:/opt/intel/libsgx-enclave-common/aesm:$AESM_PATH:" \
     | sed '/linksgx.sh/d' \
     | sed 's:/bin/mkdir:${pkgs.coreutils}/bin/mkdir:' \
     | sed 's:/bin/chown:${pkgs.coreutils}/bin/chown:' \
     | sed 's:/bin/chmod:${pkgs.coreutils}/bin/chmod:' \
     | sed 's:/bin/kill:${pkgs.utillinux}/bin/kill:' \
     > $out/lib/systemd/system/aesmd.service
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/intel/linux-sgx;
    description = "Intel's Architectural Enclave Service Manager for Intel SGX";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ exfalso ];
    license = stdenv.lib.licenses.bsd3;
  };
}
