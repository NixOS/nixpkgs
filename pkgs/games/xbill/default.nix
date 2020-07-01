{ stdenv, lib, fetchurl, libX11, libXpm, libXt, motif, ... }:

stdenv.mkDerivation rec {
  pname = "xbill";
  version = "2.1";

  buildInputs = [ libX11 libXpm libXt motif ];

  NIX_CFLAGS_LINK = "-lXpm";

  configureFlags = [
    "--with-x"
    "--enable-motif"
  ];

  src = fetchurl {
    url = "http://www.xbill.org/download/${pname}-${version}.tar.gz";
    sha256 = "13b08lli2gvppmvyhy0xs8cbjbkvrn4b87302mx0pxrdrvqzzz8f";
  };

  meta = with stdenv; {
    description = "Protect a computer network from getting infected.";
    homepage = "http://www.xbill.org/";
    license = lib.licenses.gpl1;
    maintainers = with lib.maintainers; [ aw ];
    longDescription = ''
      Ever get the feeling that nothing is going right? You're a sysadmin,
      and someone's trying to destroy your computers. The little people
      running around the screen are trying to infect your computers with
      Wingdows [TM], a virus cleverly designed to resemble a popular
      operating system.
    '';
  };
}
