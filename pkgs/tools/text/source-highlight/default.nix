{ lib, stdenv, fetchurl, boost }:

let
  name = "source-highlight";
  version = "3.1.9";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://gnu/src-highlite/${name}-${version}.tar.gz";
    sha256 = "148w47k3zswbxvhg83z38ifi85f9dqcpg7icvvw1cm6bg21x4zrs";
  };

  # source-highlight uses it's own binary to generate documentation.
  # During cross-compilation, that binary was built for the target
  # platform architecture, so it can't run on the build host.
  patchPhase = stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace Makefile.in --replace "src doc tests" "src tests"
  '';

  strictDeps = true;
  buildInputs = [ boost ];

  configureFlags = [ "--with-boost=${boost.out}" ];

  enableParallelBuilding = false;

  meta = {
    description = "Source code renderer with syntax highlighting";
    homepage = "https://www.gnu.org/software/src-highlite/";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    longDescription =
      ''
        GNU Source-highlight, given a source file, produces a document
        with syntax highlighting.
      '';
  };
}
