{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  bash,
  bashInteractive,
  util-linux,
  boto,
  setuptools,
  distro,
}:

buildPythonPackage rec {
  pname = "google-compute-engine";
  version = "20190124";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "compute-image-packages";
    rev = version;
    sha256 = "08cy0jd463kng6hwbd3nfldsp4dpd2lknlvdm88cq795wy0kh4wp";
  };

  buildInputs = [ bash ];
  propagatedBuildInputs = [
    boto
    setuptools
    distro
  ];

  postPatch = ''
    for file in $(find google_compute_engine -type f); do
      substituteInPlace "$file" \
        --replace /bin/systemctl "/run/current-system/systemd/bin/systemctl" \
        --replace /bin/bash "${bashInteractive}/bin/bash" \
        --replace /sbin/hwclock "${util-linux}/bin/hwclock"
      # SELinux tool ???  /sbin/restorecon
    done

    substituteInPlace google_config/udev/64-gce-disk-removal.rules \
      --replace /bin/sh "${bash}/bin/sh" \
      --replace /bin/umount "${util-linux}/bin/umount" \
      --replace /usr/bin/logger "${util-linux}/bin/logger"
  '';

  postInstall = ''
    # allows to install the package in `services.udev.packages` in NixOS
    mkdir -p $out/lib/udev/rules.d
    cp -r google_config/udev/*.rules $out/lib/udev/rules.d

    # sysctl snippets will be used by google-compute-config.nix
    mkdir -p $out/sysctl.d
    cp google_config/sysctl/*.conf $out/sysctl.d

    patchShebangs $out/bin/*
  '';

  doCheck = false;
  pythonImportsCheck = [ "google_compute_engine" ];

  meta = with lib; {
    description = "Google Compute Engine tools and services";
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.linux;
  };
}
