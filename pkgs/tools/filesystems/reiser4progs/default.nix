{stdenv, fetchurl, libaal}:

let version = "1.2.1"; in
stdenv.mkDerivation rec {
  name = "reiser4progs-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/reiser4-utils/${name}.tar.gz";
    sha256 = "03vdqvpyd48wxrpqpb9kg76giaffw9b8k334kr4wc0zxgybknhl7";
  };

  buildInputs = [libaal];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace configure --replace " -static" ""
  '';

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  meta = with stdenv.lib; {
    inherit version;
    homepage = https://sourceforge.net/projects/reiser4/;
    description = "Reiser4 utilities";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
