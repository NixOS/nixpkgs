{ stdenv
, fetchFromGitHub
, curl
, json_c
, pam
}:

stdenv.mkDerivation rec {
  name = "google-compute-engine-oslogin-${version}";
  version = "1.4.3";

  src = fetchFromGitHub {
    repo = "compute-image-packages";
    owner = "GoogleCloudPlatform";
    rev = "2ccfe80f162a01b5b7c3316ca37981fc8b3fc32a";
    sha256 = "036g7609ni164rmm68pzi47vrywfz2rcv0ad67gqf331pvlr92x1";
  };
  sourceRoot = "source/google_compute_engine_oslogin";

  postPatch = ''
    # change sudoers dir from /var/google-sudoers.d to /run/google-sudoers.d (managed through systemd-tmpfiles)
    substituteInPlace pam_module/pam_oslogin_admin.cc --replace /var/google-sudoers.d /run/google-sudoers.d
    # fix "User foo not allowed because shell /bin/bash does not exist"
    substituteInPlace utils/oslogin_utils.cc --replace /bin/bash ${stdenv.shell}
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

  meta = with stdenv.lib; {
    homepage = https://github.com/GoogleCloudPlatform/compute-image-packages;
    description = "OS Login Guest Environment for Google Compute Engine";
    license = licenses.asl20;
    maintainers = with maintainers; [ adisbladis flokli ];
  };
}
