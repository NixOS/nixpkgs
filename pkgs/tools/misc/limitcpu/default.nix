{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "limitcpu";
  version = "3.0";

  src = fetchurl {
    url = "mirror://sourceforge/limitcpu/cpulimit-${version}.tar.gz";
    sha256 = "sha256-rS9BXrK72j6DqKLZGO9ekPUuvMb+5h6Uv5F7PoTrtJw=";
  };

  buildFlags = with stdenv; [ (
    if isDarwin then "osx"
    else if isFreeBSD then "freebsd"
    else "cpulimit"
  ) ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://limitcpu.sourceforge.net/";
    description = "A tool to throttle the CPU usage of programs";
    platforms = with platforms; linux ++ freebsd;
    license = licenses.gpl2;
    maintainers = [maintainers.rycee];
  };
}
