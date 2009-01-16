{lib, pkgs} :
let inherit (lib) nv nvs; in
{
  # see new python derivations for example..
  # You should be able to override anything you like easily
  # grep the mailinglist by title "python proposal" (dec 08)
  # -> http://mail.cs.uu.nl/pipermail/nix-dev/2008-December/001571.html
  # to see why this got complicated when using all its features
  composableDerivation = {
          # modify args before applying stdenv.mkDerivation, this should remove at least attrs removeAttrsBy
        f ? lib.prepareDerivationArgs,
        stdenv ? pkgs.stdenv,
          # initial set of arguments to be passed to stdenv.mkDerivation passing prepareDerivationArgs by default
        initial ? {},
          # example func :  (x: x // { x.buildInputs ++ ["foo"] }), but see mergeAttrByFunc which does this for you
        merge ? (lib.mergeOrApply lib.mergeAttrByFunc)
      }: lib.applyAndFun
            (args: stdenv.mkDerivation (f args))
            merge
            (merge { inherit (lib) mergeAttrBy; } initial);

  # some utility functions
  # use this function to generate flag attrs for prepareDerivationArgs
  # E nable  D isable F eature
  edf = {name, feat ? name, enable ? {}, disable ? {} , value ? ""}:
    nvs name {
    set = {
      configureFlags = ["--enable-${feat}${if value == "" then "" else "="}${value}"];
    } // enable;
    unset = {
      configureFlags = ["--disable-${feat}"];
    } // disable;
  };

  # same for --with and --without-
  # W ith or W ithout F eature
  wwf = {name, feat ? name, enable ? {}, disable ? {}, value ? ""}:
    nvs name {
    set = {
      configureFlags = ["--with-${feat}${if value == "" then "" else "="}${value}"];
    } // enable;
    unset = {
      configureFlags = ["--without-${feat}"];
    } // disable;
  };
}
