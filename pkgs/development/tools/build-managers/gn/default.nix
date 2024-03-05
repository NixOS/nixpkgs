{ callPackage, ... } @ args:

callPackage ./generic.nix args {
  # Note: Please use the recommended version for Chromium, e.g.:
  # https://git.archlinux.org/svntogit/packages.git/tree/trunk/chromium-gn-version.sh?h=packages/gn
  rev = "fd3d768bcfd44a8d9639fe278581bd9851d0ce3a";
  revNum = "1718"; # git describe HEAD --match initial-commit | cut -d- -f3
  version = "2020-03-09";
  sha256 = "1asc14y8by7qcn10vbk467hvx93s30pif8r0brissl0sihsaqazr";
}
