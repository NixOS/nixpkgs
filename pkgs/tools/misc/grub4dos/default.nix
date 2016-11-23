{ stdenv, fetchFromGitHub, nasm }:

let arch =
  if stdenv.isi686 then "i386"
  else if stdenv.isx86_64 then "x86_64"
  else abort "Unknown architecture";
in stdenv.mkDerivation rec {
  name = "grub4dos-${version}";
  version = "0.4.6a-2016-11-09";

  src = fetchFromGitHub {
    owner = "chenall";
    repo = "grub4dos";
    rev = "4cdcd3c1aa4907e7775aa8816ca9cf0175b78bcd";
    sha256 = "17y5wsiqcb2qk1vr8n1wlhcsj668735hj8l759n8aiydw408bl55";
  };

  nativeBuildInputs = [ nasm ];

  hardeningDisable = [ "stackprotector" ];

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
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
