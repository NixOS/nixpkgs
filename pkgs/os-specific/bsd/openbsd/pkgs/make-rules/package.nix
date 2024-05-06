{
  fetchpatch,
  lib,
  mkDerivation,
}:

mkDerivation {
  path = "share/mk";
  noCC = true;

  buildInputs = [ ];
  nativeBuildInputs = [ ];

  dontBuild = true;

  patches = [
    # Use `$AR` not hardcoded `ar`
    (fetchpatch {
      name = "use-ar-variable.patch";
      url = "https://marc.info/?l=openbsd-tech&m=171575284906018&q=raw";
      hash = "sha256-bigxJGbaf9mCmFXxLVzQpnUUaEMMDfF3eZkTXVzd6B8=";
    })
    ./netbsd-make-sinclude.patch
    # Support for a new NOBLIBSTATIC make variable
    (fetchpatch {
      name = "nolibstatic-support.patch";
      url = "https://marc.info/?l=openbsd-tech&m=171972639411562&q=raw";
      hash = "sha256-p4izV6ZXkfgJud+ZZU1Wqr5qFuHUzE6qVXM7QnXvV3k=";
      includes = [ "share/mk/*" ];
    })
  ];

  postPatch = ''
    sed -i -E \
      -e 's|/usr/lib|\$\{LIBDIR\}|' \
      share/mk/bsd.prog.mk

    substituteInPlace share/mk/bsd.obj.mk --replace-fail /bin/pwd pwd
  '';

  installPhase = ''
    cp -r share/mk $out
  '';

  meta.platforms = lib.platforms.unix;
}
