{
  lib,
  mkTclDerivation,
  fetchzip,
  cffi,
  libgit2,
}:

mkTclDerivation (finalAttrs: {
  pname = "lg2";
  version = "0.2";

  src = fetchzip {
    url = "mirror://sourceforge/magicsplat/lg2/lg2-${finalAttrs.version}.zip";
    hash = "sha256-vxbXywKFojMi7e6irmvzRi2sfCdq6yzBUqWqpa687oo=";
  };

  propagatedBuildInputs = [
    cffi
  ];

  tclRequiresCheck = [
    "lg2"
  ];

  postPatch = ''
    substituteInPlace lg2.tcl \
      --replace-fail 'proc lg2_locate_libgit2 {}' 'proc lg2_locate_libgit2 {} {return ${lib.getLib libgit2}/lib/libgit2.so}
        # "comment out" the original proc
        string cat'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib/lg2 *.tcl
    mkdir -p $out/share/doc/lg2
    cp -r README.md LICENSE examples $out/share/doc/lg2

    runHook postInstall
  '';

  meta = {
    description = "Tcl bindings to the libgit2 library";
    downloadPage = "https://sourceforge.net/projects/magicsplat/files/lg2";
    homepage = "https://sourceforge.net/projects/magicsplat/files/lg2";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
