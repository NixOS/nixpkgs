{ stdenv, fetchFromGitHub, nasm }:

let arch =
  if stdenv.isi686 then "i386"
  else if stdenv.isx86_64 then "x86_64"
  else abort "Unknown architecture";
in stdenv.mkDerivation rec {
  name = "grub4dos-${version}";
  version = "0.4.6a-2016-04-26";

  src = fetchFromGitHub {
    owner = "chenall";
    repo = "grub4dos";
    rev = "61d8229375c679436d56376518456723b2025e1a";
    sha256 = "1r4jmvykk5cvpf1kysykvksa9vfy7p29q20x72inw2pbhipj0f10";
  };

  nativeBuildInputs = [ nasm ];

  configureFlags = [ "--host=${arch}-pc-linux-gnu" ];

  postInstall = ''
    mv $out/lib/grub/${arch}-pc/* $out/lib/grub
    rmdir $out/lib/grub/${arch}-pc
    chmod +x $out/lib/grub/bootlace.com
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    homepage = "http://grub4dos.chenall.net/";
    description = "GRUB for DOS is the dos extension of GRUB";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
