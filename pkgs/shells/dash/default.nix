{ lib, stdenv, buildPackages, autoreconfHook, fetchurl, libedit }:

stdenv.mkDerivation rec {
  pname = "dash";
  version = "0.5.11.2";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${pname}-${version}.tar.gz";
    sha256 = "0pvdpm1cgfbc25ramn4305a0158yq031q1ain4dc972rnxl7vyq0";
  };

  hardeningDisable = [ "format" ];

  patches = [
    (fetchurl {
      # Dash executes code when noexec ("-n") is specified
      # https://www.openwall.com/lists/oss-security/2020/11/11/3
      url = "https://git.kernel.org/pub/scm/utils/dash/dash.git/patch/?id=29d6f2148f10213de4e904d515e792d2cf8c968e";
      sha256 = "08q90bx36ixwlcj331dh7420qyj8i0qh1cc1gljrhd83fhl9w0y5";
    })
  ] ++ lib.optionals stdenv.isDarwin [
      # Temporary fix until a proper one is accepted upstream
    ./0001-fix-dirent64-et-al-on-darwin.patch
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = lib.optional stdenv.isDarwin autoreconfHook;
  buildInputs = [ libedit ];

  configureFlags = [ "--with-libedit" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 gpl2 ];
  };

  passthru = {
    shellPath = "/bin/dash";
  };
}
