R packages
==========

## Installation

Define an environment for R that contains all the libraries that you'd like to
use by adding the following snippet to your $HOME/.config/nixpkgs/config.nix file:

```nix
{
    packageOverrides = super: let self = super.pkgs; in
    {

        rEnv = super.rWrapper.override {
            packages = with self.rPackages; [
                devtools
                ggplot2
                reshape2
                yaml
                optparse
                ];
        };
    };
}
```

Then you can use `nix-env -f "<nixpkgs>" -iA rEnv` to install it into your user
profile. The set of available libraries can be discovered by running the
command `nix-env -f "<nixpkgs>" -qaP -A rPackages`. The first column from that
output is the name that has to be passed to rWrapper in the code snipped above.

However, if you'd like to add a file to your project source to make the
environment available for other contributors, you can create a `default.nix`
file like so:
```nix
let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
in with pkgs; {
  myProject = stdenv.mkDerivation {
    name = "myProject";
    version = "1";
    src = if pkgs.lib.inNixShell then null else nix;

    buildInputs = with rPackages; [
      R
      ggplot2
      knitr
    ];
  };
}
```
and then run `nix-shell .` to be dropped into a shell with those packages
available.

## RStudio

RStudio by default will not use the libraries installed like above.
You must override its R version with your custom R environment, and
set `useRPackages` to `true`, like below:

```nix
{
    packageOverrides = super: let self = super.pkgs; in
    {

        rEnv = super.rWrapper.override {
            packages = with self.rPackages; [
                devtools
                ggplot2
                reshape2
                yaml
                optparse
                ];
        };
        rstudioEnv = super.rstudio.override {
            R = rEnv;
            useRPackages = true;
        };
    };
}
```

Then like above, `nix-env -f "<nixpkgs>" -iA rstudioEnv` will install
this into your user profile.

## Updating the package set

```bash
nix-shell generate-shell.nix

Rscript generate-r-packages.R cran  > cran-packages.nix.new
mv cran-packages.nix.new cran-packages.nix

Rscript generate-r-packages.R bioc  > bioc-packages.nix.new
mv bioc-packages.nix.new bioc-packages.nix
```

`generate-r-packages.R <repo>` reads  `<repo>-packages.nix`, therefor the renaming.


## Testing if the Nix-expression could be evaluated

```bash
nix-build test-evaluation.nix --dry-run
```

If this exits fine, the expression is ok. If not, you have to edit `default.nix`
