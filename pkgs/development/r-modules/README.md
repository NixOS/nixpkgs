# R packages in NixOS

## Development environment

Define an environment for R that contains all the libraries that you'd like to
use by adding the following snippet to your $HOME/.nixpkgs/config.nix file:

```nix

{
    packageOverrides = super: let self = super.pkgs; in
    {

        rWrapper = super.rWrapper.override {
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



