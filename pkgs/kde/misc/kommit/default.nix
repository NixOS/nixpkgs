{
  lib,
  mkKdeDerivation,
  fetchurl,
  pkg-config,
  libgit2,
}:
mkKdeDerivation rec {
  pname = "kommit";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-rDDrXxqMQDXGSZ0nMl1JkSGsLeez04HKyw3XQn+0UCU=";
  };

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ libgit2 ];

  patchPhase = ''
    cat > src/data/kommitdiff.sh <<EOF
#!/bin/sh
$out/bin/kommit diff "\$@"
EOF
    cat > src/data/kommitmerge.sh <<EOF
#!/bin/sh
$out/bin/kommit merge "\$@"
EOF
  '';

  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp $out/bin/kommit
    patchShebangs --host $out/bin/kommitdiff
    patchShebangs --host $out/bin/kommitmerge
  '';

  meta.license = [ lib.licenses.gpl3Only ];
}
