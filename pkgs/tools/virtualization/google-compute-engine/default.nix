{ lib
, fetchFromGitHub
, buildPythonPackage
, bash
, bashInteractive
, util-linux
, boto
, setuptools
, distro
, stdenv
, pythonOlder
, pytestCheckHook
}:

let
  guest-configs = stdenv.mkDerivation rec {
    pname = "guest-configs";
    version = "20210702.00";

    src = fetchFromGitHub {
      owner = "GoogleCloudPlatform";
      repo = "guest-configs";
      rev = version;
      sha256 = "1965kdrb1ig3z4qwzvyzx1fb4282ak5vgxcvvg5k9c759pzbc5nn";
    };

    buildInputs = [ bash ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # allows to install the package in `services.udev.packages` in NixOS
      mkdir -p $out/lib/udev $out/bin

      cp -r "src/lib/udev/rules.d" $out/lib/udev
      cp "src/lib/udev/google_nvme_id" $out/bin

      for rules in $out/lib/udev/*.rules; do
        substituteInPlace "$rules" \
          --replace /bin/sh "${bash}/bin/sh" \
          --replace /bin/umount "${util-linux}/bin/umount" \
          --replace /usr/bin/logger "${util-linux}/bin/logger"
      done

      # sysctl snippets will be used by google-compute-config.nix
      cp -r "src/etc/sysctl.d" $out

      patchShebangs $out/bin/*

      runHook postInstall
    '';
  };
in
buildPythonPackage rec {
  pname = "google-compute-engine";
  version = "20200113.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "compute-image-packages";
    rev = "506b9a0dbffec5620887660cd42c57b3cbbadba6";
    sha256 = "0lmc426mvrajghpavhs6hwl19mgnnh08ziqx5yi15fzpnvwmb8vz";
  };

  buildInputs = [ bash guest-configs ];
  propagatedBuildInputs = [ (if pythonOlder "3.7" then boto else distro) setuptools ];

  preBuild = ''
    cd packages/python-google-compute-engine
  '';

  disabledTests = [
    "testExtractInterfaceMetadata"
    "testCallDhclientIpv6"
    "testWriteConfig"
    "testCreateInterfaceMapNetifaces"
    "testCreateInterfaceMapSysfs"
    "testGetNetworkInterface"
  ];

  checkInputs = [ pytestCheckHook ];

  postPatch = ''
    for file in $(find google_compute_engine -type f); do
      substituteInPlace "$file" \
        --replace /bin/systemctl "/run/current-system/systemd/bin/systemctl" \
        --replace /bin/bash "${bashInteractive}/bin/bash" \
        --replace /sbin/hwclock "${util-linux}/bin/hwclock"
      # SELinux tool ???  /sbin/restorecon
    done
  '';

  pythonImportsCheck = [ "google_compute_engine" ];

  meta = with lib; {
    description = "Google Compute Engine tools and services";
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud zimbatm ];
    platforms = platforms.linux;
  };
}
