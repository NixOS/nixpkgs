{ lib
, darwin
, callPackage
# For the wrapper
, symlinkJoin
, makeWrapper
, nix
}:

/*
To override the `nix` used here, use the overlay:

```
self: super: {
  nixUnstable-index = super.nix-index.override {
    nix = super.nixUnstable;
  };
}
```

If you wish to override the unwrapped derivation, use:

```
self: super: {
  nix-index-with-unwrapped-modified = super.nix-index.wrapper
    (super.nix-index.unwrapped.override { curl = curl.override { ... }; })
  ;
}
```

Or if you need overrideAttrs then use:

```
self: super: {
  nix-index-with-unwrapped-modified = super.nix-index.wrapper
    (super.nix-index.unwrapped.overrideAttrs(oldAttrs: { 
      src = super.fetchFromGitHub {
        ...
      };
      version = ...;
      patches = [
       ...
      ];
    }))
  ;
}
```

*/

let
  unwrapped = callPackage ./default.nix {
    inherit (darwin.apple_sdk.frameworks) Security;
  };
  # A function that wraps the unwrapped derivation, and gets an optional
  # argument "self" which exposes the function itself to others.
  wrapper = unwrapped: {self ? null}: symlinkJoin {
    paths = [ unwrapped ];
    name = "${unwrapped.pname}-${unwrapped.version}";
    inherit (unwrapped) meta;
    buildInputs = [ makeWrapper ];
    passthru = {
      inherit unwrapped;
      wrapper = self;
    };

    postBuild = ''
      wrapProgram $out/bin/nix-index \
        --prefix PATH : "${lib.makeBinPath [ nix ]}"
    '';
  };
in wrapper unwrapped {self = wrapper;}
