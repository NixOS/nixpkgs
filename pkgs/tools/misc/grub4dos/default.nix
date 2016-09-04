{ stdenv, fetchFromGitHub, nasm }:

let arch =
  if stdenv.isi686 then "i386"
  else if stdenv.isx86_64 then "x86_64"
  else abort "Unknown architecture";
in stdenv.mkDerivation rec {
  name = "grub4dos-${version}";
  version = "0.4.6a-2016-08-06";

  src = fetchFromGitHub {
    owner = "chenall";
    repo = "grub4dos";
    rev = "99d6ddbe7611f942d2708d77a620d6aa94a284d1";
    sha256 = "0gnllk0qkx6d0azf7v9cr0b23gp577avksz0f4dl3v3ldgi0dksq";
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
