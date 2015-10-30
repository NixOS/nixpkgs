{ stdenv, fetchurl, unzip, nasm }:

let arch =
  if stdenv.isi686 then "i386"
  else if stdenv.isx86_64 then "x86_64"
  else abort "Unknown architecture";
in stdenv.mkDerivation {
  name = "grub4dos-0.4.6a";

  src = fetchurl {
    url = https://github.com/chenall/grub4dos/archive/e855b293432bd4d155e42d48356f9aa1974ec385.zip;
    sha256 = "1vihzllsdshd5dyr7i7dp5ragyg77gg8r279pz954p7lkcda4kx7";
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
    homepage = http://grub4dos.chenall.net/;
    description = "GRUB for DOS is the dos extension of GRUB";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
