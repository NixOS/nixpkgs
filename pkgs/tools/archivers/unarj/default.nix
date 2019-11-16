{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "unarj";
  version = "2.65";

  src = fetchurl {
    sha256 = "0r027z7a0azrd5k885xvwhrxicpd0ah57jzmaqlypxha2qjw7p6p";
    url = "https://src.fedoraproject.org/repo/pkgs/unarj/${pname}-${version}.tar.gz/c6fe45db1741f97155c7def322aa74aa/${pname}-${version}.tar.gz";
  };

  preInstall = ''
    mkdir -p $out/bin
    sed -i -e s,/usr/local/bin,$out/bin, Makefile
  '';

  meta = with stdenv.lib; {
    description = "Unarchiver of ARJ files";
    license = licenses.free;
    # Vulnerable to CVE-2015-0557 & possibly CVE-2015-0556, CVE-2015-2782:
    broken = true;
  };
}
