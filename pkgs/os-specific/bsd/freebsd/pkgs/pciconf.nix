{
  lib,
  mkDerivation,
  pciutils,
}:
mkDerivation {
  path = "usr.sbin/pciconf";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  postPatch = ''
    cat >usr.sbin/pciconf/pathnames.h <<EOF
    #include <paths.h>

    #define	_PATH_DEVPCI	"/dev/pci"
    #define	_PATH_PCIVDB	"$out/share/pci.ids"
    #define	_PATH_LPCIVDB	"/red/herring"

    EOF
  '';

  postInstall = ''
    mkdir -p $out/share/misc
    cp "${pciutils}/share/pci.ids" "$out/share/pci.ids"
  '';

  meta.platorms = lib.platforms.freebsd;
  meta.mainProgram = "pciconf";
}
