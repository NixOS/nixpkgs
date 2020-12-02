{ stdenv, buildPackages, autoreconfHook, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.11.1";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "048n1rbw3v1ffzsw5mkc6zzvvf1csq7pcri7jraaqag38vqq3j3k";
  };

  hardeningDisable = [ "format" ];

  # Temporary fix until a proper one is accepted upstream
  patches = [
    (fetchurl {
      # Dash executes code when noexec ("-n") is specified
      # https://www.openwall.com/lists/oss-security/2020/11/11/3
      url = "https://git.kernel.org/pub/scm/utils/dash/dash.git/patch/?id=29d6f2148f10213de4e904d515e792d2cf8c968e";
      sha256 = "08q90bx36ixwlcj331dh7420qyj8i0qh1cc1gljrhd83fhl9w0y5";
    })
  ] ++ stdenv.lib.optional stdenv.isDarwin ./0001-fix-dirent64-et-al-on-darwin.patch;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin autoreconfHook;

  meta = with stdenv.lib; {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 gpl2 ];
  };

  passthru = {
    shellPath = "/bin/dash";
  };
}
