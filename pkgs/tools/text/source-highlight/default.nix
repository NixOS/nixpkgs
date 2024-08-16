{ lib, stdenv, fetchpatch, fetchurl, boost, updateAutotoolsGnuConfigScriptsHook }:

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
      url = "https://git.savannah.gnu.org/cgit/src-highlite.git/patch/?id=904949c9026cb772dc93fbe0947a252ef47127f4";
      hash = "sha256-h9DyD+pmlQT5dmKjWI9t0gCIYHe7pYkP55LnOqsE0vI=";
      excludes = [ "ChangeLog" ];
    })

    # Upstream fix for clang-13 and gcc-12 test support
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://git.savannah.gnu.org/cgit/src-highlite.git/patch/?id=ab9fe5cb9b85c5afab94f2a7f4b6d7d473c14ee9";
      hash = "sha256-wmSLgLnLuFE+IC6AjxzZp/HEnaOCS1VfY2cac0T7Y+w=";
    })
  ] ++ lib.optionals stdenv.cc.isClang [
    # Adds compatibility with C++17 by removing the `register` storage class specifier.
    (fetchpatch {
      name = "remove-register-keyword";
      url = "https://git.savannah.gnu.org/cgit/src-highlite.git/patch/?id=416b39758dba2c74515584514a959ad1b0ad50d1";
      hash = "sha256-R5A7IGHhU82EqceMCsuNBanhRz4dFVqiaH8637dr7jw=";
      includes = [ "lib/*" ];
    })
  ];

  # source-highlight uses it's own binary to generate documentation.
  # During cross-compilation, that binary was built for the target
  # platform architecture, so it can't run on the build host.
  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace Makefile.in --replace "src doc tests" "src tests"
  '';

  strictDeps = true;
  # necessary to build on FreeBSD native pending inclusion of
  # https://git.savannah.gnu.org/cgit/config.git/commit/?id=e4786449e1c26716e3f9ea182caf472e4dbc96e0
  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];
  buildInputs = [ boost ];

  configureFlags = [
    "--with-boost=${boost.out}"
    "--with-bash-completion=${placeholder "out"}/share/bash-completion/completions"
  ];

  doCheck = true;

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
