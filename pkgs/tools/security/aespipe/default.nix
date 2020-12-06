{ stdenv, fetchurl, sharutils, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "aespipe";
  version = "2.4f";

  src = fetchurl {
    url = "mirror://sourceforge/loop-aes/aespipe/aespipe-v${version}.tar.bz2";
    sha256 = "15pg9j27mjzl78mpzkdqd84kdafj0g6j72f8wgjrpp2qkxjy2ddi";
  };

  nativeBuildInputs = [ makeWrapper ];

  configureFlags = [ "--enable-padlock" "--enable-intelaes" ];

  postInstall = ''
    cp bz2aespipe $out/bin
    wrapProgram $out/bin/bz2aespipe \
     --prefix PATH : $out/bin:${stdenv.lib.makeBinPath [ sharutils ]}
  '';

  meta = with stdenv.lib; {
    description = "AES encrypting or decrypting pipe";
    homepage = "http://loop-aes.sourceforge.net/aespipe.README";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
