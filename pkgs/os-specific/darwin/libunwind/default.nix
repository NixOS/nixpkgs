{
  lib,
  apple-sdk,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libunwind";
  inherit (apple-sdk) version;

  # No `-lunwind` is provided becuase you get it automatically from linking with libSystem.
  # It’s also not possible to link libunwind directly, otherwise. Darwin requires going through libSystem.
  buildCommand = ''
    mkdir -p "$out/lib/pkgconfig"
    cat <<EOF > "$out/lib/pkgconfig/libunwind.pc"
    Name: libunwind
    Description: An implementation of the HP libunwind interface
    Version: ${finalAttrs.version}
    EOF
  '';

  meta = {
    description = "Compatibility package for libunwind on Darwin";
    maintainers = lib.teams.darwin.members;
    platforms = lib.platforms.darwin;
    pkgConfigModules = [ "libunwind" ];
  };
})
