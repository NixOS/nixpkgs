R packages
==========

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

## Updating the package set

To update the three main package sets, run the following commands:
```bash
nix-shell --pure generate-shell.nix --command "Rscript generate-r-packages.R cran > cran-packages.nix.new && mv cran-packages.nix.new cran-packages.nix"

nix-shell --pure generate-shell.nix --command "Rscript generate-r-packages.R bioc > bioc-packages.nix.new && mv bioc-packages.nix.new bioc-packages.nix"

nix-shell --pure generate-shell.nix --command "Rscript generate-r-packages.R irkernel > irkernel-packages.nix.new && mv irkernel-packages.nix.new irkernel-packages.nix"
```
`generate-r-packages.R <repo>` reads  `<repo>-packages.nix`, which makes the redirection/renaming necessary.


## Testing if the Nix-expression could be evaluated

```bash
nix-build test-evaluation.nix --dry-run
```

If this exits fine, the expression is ok. If not, you have to edit `default.nix`

