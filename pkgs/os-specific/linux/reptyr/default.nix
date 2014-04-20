{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.5";
  name = "reptyr-${version}";
  src = fetchurl {
    url = "https://github.com/nelhage/reptyr/archive/reptyr-${version}.tar.gz";
    sha256 = "077cvjjf534nxh7qqisw27a0wa61mdgyik43k50f8v090rggz2xm";
  };
  makeFlags = ["PREFIX=$(out)"];
  meta = {
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.mit;
    description = ''A Linux tool to change controlling pty of a process'';
  };
}
