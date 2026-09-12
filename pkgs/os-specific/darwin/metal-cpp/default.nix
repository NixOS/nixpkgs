{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

let
  mkMetalCpp =
    version: hash:
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "metal-cpp";
      inherit version;

      src = fetchFromGitHub {
        owner = "apple";
        repo = "metal-cpp";
        rev = "release/metal-cpp_${version}";
        inherit hash;
      };

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r * $out/
        runHook postInstall
      '';

      meta = {
        description = "C++ headers for the Metal framework";
        homepage = "https://github.com/apple/metal-cpp";
        license = lib.licenses.asl20;
        platforms = lib.platforms.darwin;
        maintainers = [ lib.maintainers.maxbrunet ];
      };
    });

in
lib.makeExtensible (self: {
  metal-cpp_macOS26_iOS26 = mkMetalCpp "macOS26_iOS26" "sha256-7n2eI2lw/S+Us6l7YPAATKwcIbRRpaQ8VmES7S8ZjY8=";
  metal-cpp_macOS26_4_iOS26_4 = mkMetalCpp "macOS26.4_iOS26.4" "sha256-Sw+8O4NtxicXYrohu8M+aMQk7hyH71O8cnAzzO6kbUw=";

  # Default: matches metal-toolchain version (Xcode 26.6 bundles macOS26_iOS26)
  metal-cpp = self.metal-cpp_macOS26_iOS26;
})
