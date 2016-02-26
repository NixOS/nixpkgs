{ stdenv, fetchzip, curl  }:

stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "clib-${version}";

  src = fetchzip {
    url = "https://github.com/clibs/clib/archive/${version}.zip";
    sha256 = "0hbi5hf4w0iim96h89j7krxv61x92ffxjbldxp3zk92m5sgpldnm";
  };

  hardeningDisable = [ "fortify" ];

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ curl ];

  meta = with stdenv.lib; {
    description = "C micro-package manager";
    homepage = https://github.com/clibs/clib;
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.all;
  };
}
