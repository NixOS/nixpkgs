{ lib
, fetchFromGitHub
, buildPythonApplication
, bash
, shadow
, systemd
, utillinux
, boto
, setuptools
}:

buildPythonApplication rec {
  name = "google-compute-engine-${version}";
  version = "20170914";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "compute-image-packages";
    rev = version;
    sha256 = "0hlzcrf6yhzan25f4wzy1vbncak9whhqzrzza026ly3sq0smmjpg";
  };

  postPatch = ''
    for file in $(find google_compute_engine -type f); do
      substituteInPlace "$file" \
        --replace /bin/systemctl "${systemd}/bin/systemctl" \
        --replace /bin/bash "${bash}/bin/bash" \
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

  propagatedBuildInputs = [ boto setuptools ];

  meta = with lib; {
    description = "Google Compute Engine tools and services";
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
