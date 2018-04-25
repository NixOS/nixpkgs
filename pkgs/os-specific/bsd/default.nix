{ callPackages, recurseIntoAttrs }:

rec {
  netbsd = recurseIntoAttrs (callPackages ./netbsd {});
  openbsd = recurseIntoAttrs (callPackages ./openbsd {
    inherit (netbsd) compat netBSDDerivation libcurses;
  });
}
