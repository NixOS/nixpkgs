{
  lib,
  stdenv,
  fetchurl,
  cmake,
  swig,
  wireshark,
  check,
  rsync,
  libpcap,
  gawk,
  libedit,
  pcre,
  nixosTests,
}:

let
  version = "0.3.0";
in

stdenv.mkDerivation {
  pname = "haka";
  inherit version;

  src = fetchurl {
    name = "haka_${version}_source.tar.gz";
    url = "https://github.com/haka-security/haka/releases/download/v${version}/haka_${version}_source.tar.gz";
    sha256 = "0dm39g3k77sa70zrjsqadidg27a6iqq61jzfdxazpllnrw4mjy4w";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  preConfigure = ''
    sed -i 's,/etc,'$out'/etc,' src/haka/haka.c
    sed -i 's,/etc,'$out'/etc,' src/haka/CMakeLists.txt
    sed -i 's,/opt/haka/etc,$out/opt/haka/etc,' src/haka/haka.1
    sed -i 's,/etc,'$out'/etc,' doc/user/tool_suite_haka.rst
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    swig
    wireshark
    check
    rsync
    libpcap
    gawk
    libedit
    pcre
  ];

  passthru.tests = { inherit (nixosTests) haka; };

  meta = {
    description = "A collection of tools that allows capturing TCP/IP packets and filtering them based on Lua policy files";
    homepage = "http://www.haka-security.org/";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.tvestelind ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ]; # fails on aarch64
  };
}
