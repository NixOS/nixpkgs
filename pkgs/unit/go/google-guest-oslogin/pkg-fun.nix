{ stdenv
, lib
, bashInteractive
, curl
, fetchFromGitHub
, json_c
, nixosTests
, pam
}:

stdenv.mkDerivation rec {
  pname = "google-guest-oslogin";
  version = "20220721.00";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "guest-oslogin";
    rev = version;
    sha256 = "sha256-VIbejaHN9ANk+9vjpGAYS/SjHx4Tf7SkTqRD1svJRPU=";
  };

  postPatch = ''
    # change sudoers dir from /var/google-sudoers.d to /run/google-sudoers.d (managed through systemd-tmpfiles)
    substituteInPlace src/pam/pam_oslogin_admin.cc --replace /var/google-sudoers.d /run/google-sudoers.d
    # fix "User foo not allowed because shell /bin/bash does not exist"
    substituteInPlace src/include/compat.h --replace /bin/bash /run/current-system/sw/bin/bash
  '';

  buildInputs = [ curl.dev pam json_c ];

  NIX_CFLAGS_COMPILE = [ "-I${json_c.dev}/include/json-c" ];

  makeFlags = [
    "VERSION=${version}"
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man"
    "SYSTEMDDIR=$(out)/etc/systemd/system"
    "PRESETDIR=$(out)/etc/systemd/system-preset"
  ];

  postInstall = ''
    sed -i "s,/usr/bin/,$out/bin/,g" $out/etc/systemd/system/google-oslogin-cache.service
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) google-oslogin;
  };

  meta = with lib; {
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    description = "OS Login Guest Environment for Google Compute Engine";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ flokli ];
  };
}
