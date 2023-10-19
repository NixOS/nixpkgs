{ lib
, hwdata
, pkg-config
, lxc
, buildGoModule
, fetchurl
, acl
, libcap
, dqlite
, raft-canonical
, sqlite
, udev
, installShellFiles
, nixosTests
, gitUpdater
, callPackage
}:

buildGoModule rec {
  pname = "lxd-unwrapped";
  version = "5.18";

  src = fetchurl {
    url = "https://github.com/canonical/lxd/releases/download/lxd-${version}/lxd-${version}.tar.gz";
    hash = "sha256-4F4q+jnypE4I2/5D65UT3NRpdJertSRni8JvHkpTFVI=";
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace shared/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = [ "test" "lxd/db/generate" "lxd-agent" "lxd-migrate" ];

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [
    lxc
    acl
    libcap
    dqlite.dev
    raft-canonical.dev
    sqlite
    udev.dev
  ];

  ldflags = [ "-s" "-w" ];
  tags = [ "libsqlite3" ];

  preBuild = ''
    # required for go-dqlite. See: https://github.com/canonical/lxd/pull/8939
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
  '';

  # build static binaries: https://github.com/canonical/lxd/blob/6fd175c45e65cd475d198db69d6528e489733e19/Makefile#L43-L51
  postBuild = ''
    make lxd-agent lxd-migrate
  '';

  preCheck =
    let skippedTests = [
      "TestValidateConfig"
      "TestConvertNetworkConfig"
      "TestConvertStorageConfig"
      "TestSnapshotCommon"
      "TestContainerTestSuite"
    ]; in
    ''
      # Disable tests requiring local operations
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  postInstall = ''
    installShellCompletion --bash --name lxd ./scripts/bash/lxd-client
  '';

  passthru.tests.lxd = nixosTests.lxd;
  passthru.ui = callPackage ./ui.nix { };
  passthru.updateScript = gitUpdater {
    url = "https://github.com/canonical/lxd.git";
    rev-prefix = "lxd-";
  };

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://ubuntu.com/lxd";
    changelog = "https://github.com/canonical/lxd/releases/tag/lxd-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam adamcstephens ];
    platforms = platforms.linux;
  };
}
