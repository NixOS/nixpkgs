{ stdenv, fetchFromGitHub, autoreconfHook, payload ? null }: let
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

  configureFlags = stdenv.lib.optional (payload != null)
    "--with-payload=${payload}";

  hardeningDisable = [ "all" ];

  postInstall = ''
    mv $out/* $out/.cleanup
    mv $out/.cleanup/* $out
    rmdir $out/.cleanup
  '';

  meta = {
    description = "RISC-V Proxy Kernel and Bootloader.";
    homepage = https://github.com/riscv/riscv-pk;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.riscv;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
