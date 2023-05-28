# apple-sdks

This document describes the different components which go into producing the Apple SDKs (versions later than 11.0) in Nixpkgs.

## Frameworks and Libraries

Generally, Each release of the SDK has a number of libraries and frameworks associated with it.

### Libraries

**TODO(@connorbaker):** further documentation.

### Frameworks

We store the logic and data for each SDK's frameworks `frameworks/sdk-version`, where `sdk-version` is something like `13.3.0`. The `frameworks/default.nix` file contains a function which produces our final framework derivations, combining the information in the files `public.nix`, `private.nix`, and `fixups.nix` in `frameworks/sdk-version`. The `frameworks/default.nix` expression infers the SDK version to build by looking at the `version` attribute of the `MacOSX-SDK` derivation it takes as an argument.

#### Public frameworks

Currently, we use `gen-frameworks.py` to create the `frameworks/sdk-version/public.nix` files we need. Unfortunately, the script doesn't always get all available frameworks, nor capture all necessary dependencies. In particular, private frameworks aren't captured by the script.

The easiest way to run the script is by using its `--from-apple-sdk-releases` option which will cause it to generate a `public.nix` file for each SDK version in `apple-sdk-releases.json`. An example invocation is:

```sh
./gen-frameworks.py --from-apple-sdk-releases ../apple-sdk-releases.json
```

Currently, there is no way to specify the directory to place the generated directories and files in, so be sure to run the script from the `frameworks` directory!

#### Private frameworks

Finding out which private frameworks are exposed in the SDK or used in Nixpkgs is a pain. The best @connorbaker has been able to figure out so far is adding entries to `frameworks/sdk-version/private.nix` as they are encountered. This is tedious and error-prone.

#### Framework fixups

Beyond exposing frameworks, there's typically some amount of "fixing up" needed for them to work properly. For example, because private frameworks aren't picked up by `gen-frameworks.py`, we have to manually add dependencies on private frameworks to the public frameworks. To separate the manual from automatically-generated Nix files, we use `frameworks/sdk-version/fixups.nix` as a place to store this information.

The `frameworks/sdk-version/fixups.nix` file contains three attributes:

- `addToFrameworks`
- `removeFromFrameworks`
- `overrideFrameworks`

The `addToFrameworks` attribute is an attribute set where each key is the name of a framework and each value is an attribute set of dependencies to add to the named framework.

The `removeFromFrameworks` attribute is an attribute set where each key is the name of a framework and each value is an attribute set of dependencies to remove from the named framework.

The `overrideFrameworks` attribute is function which accepts an attribute set of framework derivations and returns an attribute set of framework derivations. This is useful for doing things like modifying the `buildPhase` or `installPhase` of a framework.
