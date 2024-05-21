{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "oonf-olsrd2";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "OLSR";
    repo = "OONF";
    rev = "v${version}";
    hash = "sha256-7EH2K7gaBGD95WFlG6RRhKEWJm91Xv2GOHYQjZWuzl0=";
  };

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: CMakeFiles/oonf_dlep_proxy.dir/router/dlep_router_session.c.o:(.bss+0x0):
  #     multiple definition of `LOG_DLEP_ROUTER'; CMakeFiles/oonf_dlep_proxy.dir/router/dlep_router.c.o:(.bss+0x0): first defined here
  # Can be removed once release with https://github.com/OLSR/OONF/pull/40 is out.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  cmakeFlags = [
    "-DOONF_NO_WERROR=yes"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "An adhoc wireless mesh routing daemon";
    license = licenses.bsd3;
    homepage = "http://olsr.org/";
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
