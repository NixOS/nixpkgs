{ lib
, fetchFromGitHub
, buildPythonApplication
, bash
, bashInteractive
, systemd
, utillinux
, boto
, setuptools
, distro
}:

buildPythonApplication rec {
  name = "google-compute-engine-${version}";
  version = "20181206";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "compute-image-packages";
    rev = version;
    sha256 = "090gbkfk3jh403jzs133isxk8263i16vnj5021l7pxbjgj1zzzwf";
  };

  postPatch = ''
    for file in $(find google_compute_engine -type f); do
      substituteInPlace "$file" \
        --replace /bin/systemctl "${systemd}/bin/systemctl" \
        --replace /bin/bash "${bashInteractive}/bin/bash" \
        --replace /sbin/hwclock "${utillinux}/bin/hwclock"

      # SELinux tool ???  /sbin/restorecon
    done

    substituteInPlace google_config/udev/64-gce-disk-removal.rules \
      --replace /bin/sh "${bash}/bin/sh" \
      --replace /bin/umount "${utillinux}/bin/umount" \
      --replace /usr/bin/logger "${utillinux}/bin/logger"
  '';

  postInstall = ''
    # allows to install the package in `services.udev.packages` in NixOS
    mkdir -p $out/lib/udev/rules.d
    cp -r google_config/udev/*.rules $out/lib/udev/rules.d
  '';

  propagatedBuildInputs = [ boto setuptools distro ];

  doCheck = false;

  meta = with lib; {
    description = "Google Compute Engine tools and services";
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.linux;
  };
}
