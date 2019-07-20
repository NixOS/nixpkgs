{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.3.110";
  name = "libaio-${version}";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/libaio/${name}.tar.gz";
    sha256 = "0zjzfkwd1kdvq6zpawhzisv7qbq1ffs343i5fs9p498pcf7046g0";
  };

  patches = [ (fetchpatch {
    url = https://pagure.io/libaio/c/da47c32b2ff39e52fbed1622c34b86bc88d7c217.patch;
    sha256 = "1kqpiswjn549s3w3m89bw5qkl7bw5pvq6gp5cdzd926ymlgivj5c";
  }) ];

  postPatch = ''
    patchShebangs harness

    # Makefile is too optimistic, gcc is too smart
    substituteInPlace harness/Makefile \
      --replace "-Werror" ""
  '';

  makeFlags = "prefix=$(out)";

  hardeningDisable = stdenv.lib.optional (stdenv.isi686) "stackprotector";

  checkTarget = "partcheck"; # "check" needs root

  meta = {
    description = "Library for asynchronous I/O in Linux";
    homepage = http://lse.sourceforge.net/io/aio.html;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
