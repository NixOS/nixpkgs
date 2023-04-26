{ lib
, derivationWithMeta
, system
, src
, version
}:
derivationWithMeta {
  inherit system version;
  pname = "hex0";
  builder = "${src}/bootstrap-seeds/POSIX/x86/hex0-seed";
  args = [
    "${src}/bootstrap-seeds/POSIX/x86/hex0_x86.hex0"
    (placeholder "out")
  ];

  meta = with lib; {
    description = "Minimal assembler for bootstrapping";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };
}
