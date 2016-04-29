{ stdenv, fetchurl, unzip, nasm }:

let arch =
  if stdenv.isi686 then "i386"
  else if stdenv.isx86_64 then "x86_64"
  else abort "Unknown architecture";
in stdenv.mkDerivation {
  name = "grub4dos-0.4.6a-2015-12-31";

  src = fetchurl {
    url = https://github.com/chenall/grub4dos/archive/a8024743c61cc4909514b27df07b7cc4bc89d1fb.zip;
    sha256 = "1m5d7klb12qz5sa09919z7jchfafgh84cmpwilp52qnbpi3zh2fd";
  };

  nativeBuildInputs = [ unzip nasm ];

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
