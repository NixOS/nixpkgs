{ lib
, SDL2
}:

# The following is list of overrides that take three arguments each:
# - lockAttrs: - an attrset from a Nim lockfile, use this for making constraints on the locked library
# - finalAttrs: - final arguments to the depender package
# - prevAttrs: - preceding arguments to the depender package
{

  sdl2 = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ SDL2 ];
    };

}
