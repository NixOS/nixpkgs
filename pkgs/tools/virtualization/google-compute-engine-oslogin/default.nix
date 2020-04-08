{ stdenv
, fetchFromGitHub
, curl
, json_c
, pam
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "google-compute-engine-oslogin";
  version = "1.5.3";
  # from packages/google-compute-engine-oslogin/packaging/debian/changelog

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "compute-image-packages";
    rev = "20190522";
    sha256 = "16jbbrnz49g843h813r408dbvfa2hicf8canxwbfxr2kzhv7ycmm";
  };
  sourceRoot = "source/packages/google-compute-engine-oslogin";

  postPatch = ''
    # change sudoers dir from /var/google-sudoers.d to /run/google-sudoers.d (managed through systemd-tmpfiles)
    substituteInPlace pam_module/pam_oslogin_admin.cc --replace /var/google-sudoers.d /run/google-sudoers.d
    # fix "User foo not allowed because shell /bin/bash does not exist"
    substituteInPlace compat.h --replace /bin/bash ${bashInteractive}/bin/bash
  '';

  buildInputs = [ curl.dev pam ];

  NIX_CFLAGS_COMPILE="-I${json_c.dev}/include/json-c";
  NIX_CFLAGS_LINK="-L${json_c}/lib";

  installPhase = ''
    mkdir -p $out/{bin,lib}

    install -Dm755 libnss_cache_google-compute-engine-oslogin-${version}.so $out/lib/libnss_cache_oslogin.so.2
    install -Dm755 libnss_google-compute-engine-oslogin-${version}.so $out/lib/libnss_oslogin.so.2

    install -Dm755 pam_oslogin_admin.so pam_oslogin_login.so $out/lib
    install -Dm755 google_{oslogin_nss_cache,authorized_keys} $out/bin
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/GoogleCloudPlatform/compute-image-packages;
    description = "OS Login Guest Environment for Google Compute Engine";
    license = licenses.asl20;
    maintainers = with maintainers; [ adisbladis flokli ];
  };
}
