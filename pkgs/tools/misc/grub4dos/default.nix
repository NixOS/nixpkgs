{ stdenv, fetchFromGitHub, nasm }:

let arch =
  if stdenv.isi686 then "i386"
  else if stdenv.isx86_64 then "x86_64"
  else throw "Unknown architecture";
in stdenv.mkDerivation rec {
  name = "grub4dos-${version}";
  version = "0.4.6a-2016-12-24";

  src = fetchFromGitHub {
    owner = "chenall";
    repo = "grub4dos";
    rev = "ca0371bb1e2365bfe4e44031a3b8b59e8c58ce0d";
    sha256 = "0a9m7n5la3dmbfx6n5iqlfbm607r1mww0wkimn29mlsc30d8aamr";
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
    homepage = http://grub4dos.chenall.net/;
    description = "GRUB for DOS is the dos extension of GRUB";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
