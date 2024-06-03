{ lib, stdenv, fetchurl, sharutils, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "aespipe";
  version = "2.4h";

  src = fetchurl {
    url = "mirror://sourceforge/loop-aes/aespipe/aespipe-v${version}.tar.bz2";
    sha256 = "sha256-6rMR/CbqQyibw632YNYnBJJJSWByXSAm7EkXKUoaukk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  configureFlags = [ "--enable-padlock" "--enable-intelaes" ];

  postInstall = ''
    cp bz2aespipe $out/bin
    wrapProgram $out/bin/bz2aespipe \
     --prefix PATH : $out/bin:${lib.makeBinPath [ sharutils ]}
  '';

  meta = with lib; {
    description = "AES encrypting or decrypting pipe";
    homepage = "https://loop-aes.sourceforge.net/aespipe.README";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
