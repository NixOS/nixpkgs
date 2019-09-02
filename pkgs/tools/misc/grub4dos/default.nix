{ stdenv, fetchFromGitHub, nasm }:

let arch =
  if stdenv.isi686 then "i386"
  else if stdenv.isx86_64 then "x86_64"
  else throw "Unknown architecture";
in stdenv.mkDerivation rec {
  pname = "grub4dos";
  version = "0.4.6a-2019-05-12";

  src = fetchFromGitHub {
    owner = "chenall";
    repo = "grub4dos";
    rev = "e8224a2d20760139ffaeafa07838e2c3c54de783";
    sha256 = "0i7n71za43qnlsxfvjrv1z5g1w5jl9snpbnas7rw97rry7cgyswf";
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

  # make[2]: *** No rule to make target 'pre_stage2_fullsize', needed by 'all-am'.  Stop.
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    homepage = http://grub4dos.chenall.net/;
    description = "GRUB for DOS is the dos extension of GRUB";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
