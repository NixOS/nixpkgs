{ lib
, stdenv
, fetchurl
, gcc
, makeWrapper
, pcre
, ps
, readline
, tcp_wrappers
}:

stdenv.mkDerivation rec {
  pname = "atftp";
  version = "0.7.5";

  src = fetchurl {
    url = "mirror://sourceforge/atftp/${pname}-${version}.tar.gz";
    sha256 = "12h3sgkd25j4nfagil2jqyj1n8yxvaawj0cf01742642n57pmj4k";
  };

  # fix test script
  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    gcc
    pcre
    readline
    tcp_wrappers
  ];

  checkInputs = [
    ps
  ];

  # Expects pre-GCC5 inline semantics
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  doCheck = true;

  meta = with lib; {
    description = "Advanced tftp tools";
    changelog = "https://sourceforge.net/p/atftp/code/ci/v${version}/tree/Changelog";
    homepage = "https://sourceforge.net/projects/atftp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
