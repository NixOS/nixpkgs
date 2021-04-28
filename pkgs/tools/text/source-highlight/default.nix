{ lib, stdenv, fetchurl, boost }:

stdenv.mkDerivation rec {
  pname = "source-highlight";
  version = "3.1.9";

  src = fetchurl {
    url = "mirror://gnu/src-highlite/${pname}-${version}.tar.gz";
    sha256 = "148w47k3zswbxvhg83z38ifi85f9dqcpg7icvvw1cm6bg21x4zrs";
  };

  # source-highlight uses it's own binary to generate documentation.
  # During cross-compilation, that binary was built for the target
  # platform architecture, so it can't run on the build host.
  patchPhase = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace Makefile.in --replace "src doc tests" "src tests"
  '';

  strictDeps = true;
  buildInputs = [ boost ];

  configureFlags = [ "--with-boost=${boost.out}" ];

  enableParallelBuilding = false;

  outputs = [ "out" "doc" "dev" ];

  meta = with lib; {
    description = "Source code renderer with syntax highlighting";
    longDescription = ''
      GNU Source-highlight, given a source file, produces a document
      with syntax highlighting.
    '';
    homepage = "https://www.gnu.org/software/src-highlite/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
