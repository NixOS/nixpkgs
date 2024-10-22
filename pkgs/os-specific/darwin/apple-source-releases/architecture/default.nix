{ lib, appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontBuild = true;

  postPatch = ''
    substituteInPlace Makefile \
        --replace '/bin/mkdir' 'mkdir' \
        --replace '/usr/bin/install' 'install'
  '';

  installFlags = [ "EXPORT_DSTDIR=/include/architecture" ];

  DSTROOT = "$(out)";

  appleHeaders = ''
    architecture/alignment.h
    architecture/byte_order.h
    architecture/i386/alignment.h
    architecture/i386/asm_help.h
    architecture/i386/byte_order.h
    architecture/i386/cpu.h
    architecture/i386/desc.h
    architecture/i386/fpu.h
    architecture/i386/frame.h
    architecture/i386/io.h
    architecture/i386/pio.h
    architecture/i386/reg_help.h
    architecture/i386/sel.h
    architecture/i386/table.h
    architecture/i386/tss.h
  '';

  meta = with lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
