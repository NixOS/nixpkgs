{ stdenv, fetchFromGitHub, autoreconfHook }: let
  rev = "e5846a2bc707eaa58dc8ab6a8d20a090c6ee8570";
  sha256 = "1clynpp70fnbgsjgxx7xi0vrdrj1v0h8zpv0x26i324kp2gwylf4";
  revCount = "438";
  shortRev = "e5846a2";
in stdenv.mkDerivation {
  name = "riscv-pk-0.1pre${revCount}_${shortRev}";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-pk";
    inherit rev sha256;
  };

  nativeBuildInputs = [ autoreconfHook ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  hardeningDisable = [ "all" ];

  meta = {
    description = "RISC-V Proxy Kernel and Bootloader.";
    homepage = https://github.com/riscv/riscv-pk;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
