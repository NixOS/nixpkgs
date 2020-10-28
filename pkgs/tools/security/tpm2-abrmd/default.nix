{ stdenv, lib, fetchFromGitHub
, autoreconfHook, pkg-config, autoconf-archive, makeWrapper, which
, tpm2-tss, glib, dbus
, cmocka
}:

stdenv.mkDerivation rec {
  pname = "tpm2-abrmd";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = pname;
    rev = version;
    sha256 = "17nv50w1yh6fg7393vfvys9y13lp0gvxx9vcw2pb87ky551d7xkf";
  };

  nativeBuildInputs = [ pkg-config makeWrapper autoreconfHook autoconf-archive which ];
  buildInputs = [ tpm2-tss glib dbus ];
  checkInputs = [ cmocka ];

  enableParallelBuilding = true;

  # Emulate the required behavior of ./bootstrap in the original
  # package
  preAutoreconf = ''
    echo "${version}" > VERSION
  '';

  # Unit tests are currently broken as the check phase attempts to start a dbus daemon etc.
  #configureFlags = [ "--enable-unit" ];
  doCheck = false;

  # Even though tpm2-tss is in the RUNPATH, starting from 2.3.0 abrmd
  # seems to require the path to the device TCTI (used for accessing
  # /dev/tpm0) in it's LD_LIBRARY_PATH
  postFixup = ''
    wrapProgram $out/bin/tpm2-abrmd \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ tpm2-tss ]}"
  '';

  meta = with lib; {
    description = "TPM2 resource manager, accessible via D-Bus";
    homepage = "https://github.com/tpm2-software/tpm2-tools";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
