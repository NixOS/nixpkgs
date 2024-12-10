{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  payload ? null,
}:

stdenv.mkDerivation rec {
  pname = "riscv-pk";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-pk";
    rev = "v${version}";
    sha256 = "1cc0rz4q3a1zw8756b8yysw8lb5g4xbjajh5lvqbjix41hbdx6xz";
  };

  nativeBuildInputs = [ autoreconfHook ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  configureFlags = lib.optional (payload != null) "--with-payload=${payload}";

  hardeningDisable = [ "all" ];

  postInstall = ''
    mv $out/* $out/.cleanup
    mv $out/.cleanup/* $out
    rmdir $out/.cleanup
  '';

  meta = {
    description = "RISC-V Proxy Kernel and Bootloader";
    homepage = "https://github.com/riscv/riscv-pk";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.riscv;
    maintainers = [ lib.maintainers.shlevy ];
  };
}
