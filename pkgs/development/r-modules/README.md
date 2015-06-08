# R packages in NixOS

## Installation
Define an environment for R that contains all the libraries that you'd like to
use by adding the following snippet to your $HOME/.nixpkgs/config.nix file:

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
Generally speaking, we have all of CRAN.

## Updating the CRAN package set

```bash
Rscript generate-cran-packages.R > cran-packages.nix.new
mv cran-packages.nix.new cran-packages.nix
```

`generate-cran-packages.R` reads  `cran-packages.nix`, therefor the renaming.

## Testing if the Nix-expression could be evaluated

```bash
nix-env -f ../../.. -qaP -A rPackages | tail -1
edit default.nix
```

If this exits fine, the expression is ok.



