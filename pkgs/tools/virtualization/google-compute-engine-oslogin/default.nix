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
  pname = "google-compute-engine-oslogin";
  version = "20200507.00";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "guest-oslogin";
    rev = version;
    sha256 = "1np8c96sm29pwnxykc0id8kkgalhw576g43fgi1y936sr2hfvx3v";
  };

  postPatch = ''
    # change sudoers dir from /var/google-sudoers.d to /run/google-sudoers.d (managed through systemd-tmpfiles)
    substituteInPlace src/pam/pam_oslogin_admin.cc --replace /var/google-sudoers.d /run/google-sudoers.d
    # fix "User foo not allowed because shell /bin/bash does not exist"
    substituteInPlace src/include/compat.h --replace /bin/bash ${bashInteractive}/bin/bash
  '';

  buildInputs = [ curl.dev pam ];

  NIX_CFLAGS_COMPILE="-I${json_c.dev}/include/json-c";
  NIX_CFLAGS_LINK="-L${json_c}/lib";

  makeFlags = [
    "VERSION=${version}"
    "DESTDIR=${placeholder "out"}"
    "PREFIX=/"
    "BINDIR=/bin"
    "LIBDIR=/lib"
    "PAMDIR=/lib"
    "MANDIR=/share/man"
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) google-oslogin;
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/GoogleCloudPlatform/compute-image-packages";
    description = "OS Login Guest Environment for Google Compute Engine";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
