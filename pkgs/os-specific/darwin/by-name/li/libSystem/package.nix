{ stdenvNoCC }:

# Darwin dynamically determines the `libSystem` to use based on the SDK found at `DEVELOPER_DIR`.
# By default, this will be `apple-sdk` or one of the versioned variants.
stdenvNoCC.mkDerivation {
  pname = "libSystem";
  version = "B";

  # Silence linker warnings due a missing `lib` (which is added by cc-wrapper).
  buildCommand = ''
    mkdir -p "$out/include" "$out/lib"
  '';
}
