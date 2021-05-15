{ lib, stdenv, fetchurl, openssl, perl, trousers, zlib }:

stdenv.mkDerivation rec {
  pname = "tboot";
  version = "1.10.1";

  src = fetchurl {
    url = "mirror://sourceforge/tboot/${pname}-${version}.tar.gz";
    sha256 = "18bnkwnlk16cc20nysqfcjx006idi7jmmhahk8vk09w458bhaajg";
  };

  buildInputs = [ openssl trousers zlib ];

  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace tboot/Makefile --replace /usr/bin/perl ${perl}/bin/perl

    for a in lcptools-v2 tb_polgen utils; do
      substituteInPlace "$a/Makefile" --replace /usr/sbin /sbin
    done
    substituteInPlace docs/Makefile --replace /usr/share /share
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "A pre-kernel/VMM module that uses Intel(R) TXT to perform a measured and verified launch of an OS kernel/VMM";
    homepage    = "https://sourceforge.net/projects/tboot/";
    changelog   = "https://sourceforge.net/p/tboot/code/ci/v${version}/tree/CHANGELOG";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ ak ];
    platforms   = [ "x86_64-linux" "i686-linux" ];
  };
}
