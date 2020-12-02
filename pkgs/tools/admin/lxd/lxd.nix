{ lib
, buildGoPackage
, installShellFiles
, pkg-config
, hwdata, lxc, acl, libcap, libco-canonical, dqlite
, raft-canonical, sqlite-replication, udev
, src, version
}:

buildGoPackage rec {
  inherit version src;

  pname = "lxd-unwrapped";

  goPackagePath = "github.com/lxc/lxd";

  postPatch = ''
    substituteInPlace shared/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  preBuild = ''
    # unpack vendor
    pushd go/src/github.com/lxc/lxd
    rm _dist/src/github.com/lxc/lxd
    cp -r _dist/src/* ../../..
    popd
  '';

  buildFlags = [ "-tags libsqlite3" ];

  postInstall = ''
    installShellCompletion --bash --name lxd go/src/github.com/lxc/lxd/scripts/bash/lxd-client
  '';

  subPackages = [ "fuidshift" "lxc" "lxc-to-lxd" "lxd" "lxd-benchmark" "lxd-p2c" ];

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ lxc acl libcap libco-canonical.dev dqlite.dev
                  raft-canonical.dev sqlite-replication udev.dev ];

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://linuxcontainers.org/lxd/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz wucke13 ];
    platforms = platforms.linux;
  };
}
