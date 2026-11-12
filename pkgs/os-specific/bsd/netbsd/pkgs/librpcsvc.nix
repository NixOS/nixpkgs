{
  lib,
  buildPackages,
  mkDerivation,
  defaultMakeFlags,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  tsort,
  lorder,
  rpcgen,
  statHook,
}:

mkDerivation {
  path = "lib/librpcsvc";

  libcMinimal = true;

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    tsort
    lorder
    rpcgen
    statHook
  ];

  makeFlags = defaultMakeFlags ++ [
    "INCSDIR=$(dev)/include/rpcsvc"
    # `rpcgen` shells out to a C preprocessor, and 11.0 defaults that to
    # `/usr/bin/clang-cpp`, which does not exist here. It fails *softly*: the
    # generated stubs come out empty, so the library builds and links but
    # exports none of its symbols, and the first sign of trouble is NetBSD's
    # own expected-symbol check much later:
    #
    #     librpcsvc.so.1.0: error: actual symbols differ from expected symbols
    #
    # `include` already passes this; librpcsvc needs it for the same reason.
    #
    # It has to be the *build* compiler: `rpcgen` runs here, and the cross gcc
    # installs only target-prefixed binaries, so it has no plain `cpp`.
    "RPCGEN_CPP=${buildPackages.stdenv.cc.cc}/bin/cpp"
  ];

  meta.platforms = lib.platforms.netbsd;
}
