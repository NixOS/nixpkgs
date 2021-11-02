{ lib, stdenv, fetchpatch, fetchurl, boost }:

stdenv.mkDerivation rec {
  pname = "source-highlight";
  version = "3.1.9";

  outputs = [ "out" "doc" "dev" ];

  src = fetchurl {
    url = "mirror://gnu/src-highlite/${pname}-${version}.tar.gz";
    sha256 = "148w47k3zswbxvhg83z38ifi85f9dqcpg7icvvw1cm6bg21x4zrs";
  };

  patches = [
    # gcc-11 compat upstream patch
    (fetchpatch {
      url = "http://git.savannah.gnu.org/cgit/src-highlite.git/patch/?id=904949c9026cb772dc93fbe0947a252ef47127f4";
      sha256 = "1wnj0jmkmrwjww7qk9dvfxh8h06jdn7mi8v2fvwh95b6x87z5l47";
      excludes = [ "ChangeLog" ];
    })
  ];

  # source-highlight uses it's own binary to generate documentation.
  # During cross-compilation, that binary was built for the target
  # platform architecture, so it can't run on the build host.
  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace Makefile.in --replace "src doc tests" "src tests"
  '';

  strictDeps = true;
  buildInputs = [ boost ];

  configureFlags = [
    "--with-boost=${boost.out}"
    "--with-bash-completion=${placeholder "out"}/share/bash_completion.d"
  ];

  doCheck = !stdenv.cc.isClang;

  enableParallelBuilding = true;
  # Upstream uses the same intermediate files in multiple tests, running
  # them in parallel by make will eventually break one or more tests.
  enableParallelChecking = false;

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
