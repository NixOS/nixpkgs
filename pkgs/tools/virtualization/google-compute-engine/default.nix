{ lib
, fetchFromGitHub
, pythonPackages
, bash
, shadow
, systemd
, utillinux
}:
let
  version = "20170523";
in
pythonPackages.buildPythonApplication {
  name = "google-compute-engine-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "compute-image-packages";
    rev = version;
    sha256 = "1qxyj3lj9in6m8yi6y6wcmc3662h9z4qax07v97rdnay99mxdv68";
  };

  patches = [ ./0001-allow-nologin-other-paths.patch ];

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

  propagatedBuildInputs = with pythonPackages; [ boto setuptools ];

  meta = with lib; {
    description = "Google Compute Engine tools and services";
    homepage = https://github.com/GoogleCloudPlatform/compute-image-packages;
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
