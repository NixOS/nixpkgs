{
  mkDerivation,
  libnv,
}:
mkDerivation {
  path = "lib/libnvmf";
  extraPaths = [
    "sys/libkern"
    "sys/dev/nvmf"
  ];
  buildInputs = [ libnv ];

  postPatch = ''
    sed -E -i -e '/INTERNALLIB/d' lib/libnvmf/Makefile
  '';
  postInstall = ''
    ln -s libnvmf.a $out/lib/libnvmf_pie.a
  '';

  alwaysKeepStatic = true;
}
