{ lib
, stdenv
, fetchgit
, libbsd
, readline
}:

stdenv.mkDerivation rec {
  pname = "rosie";
  version = "1.3.0";

  src = fetchgit {
    url = "https://gitlab.com/rosie-pattern-language/rosie";
    rev = "9303e04ae2cffabdda6ccc4e2a351a47218615ff";
    sha256 = "1smh760baf43hr56p6rh4khz3shyzda5lqva4ffxwchl7yy7r82j";
    fetchSubmodules = true;
  };

  postUnpack = ''
    # The Makefile calls git to update submodules, unless this file exists
    touch ${src.name}/submodules/~~present~~
  '';

  preConfigure = ''
    patchShebangs src/build_info.sh
    # rosie is ran as part of `make check`,
    # and so needs to be patched in preConfigure.
    patchShebangs rosie
    # Part of the same Makefile target which calls git to update submodules
    ln -s src submodules/lua/include
    # ldconfig is irrelevant, disable it inside `make installforce`.
    sed -iE 's/ldconfig/echo skippin ldconfig/' Makefile
    sed -iE '/ld.so.conf.d/d' Makefile
  '';

  preInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath $out/lib build/bin/rosie
    install_name_tool -id $out/lib/librosie.dylib build/lib/librosie.dylib
  '';

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp $out/share/vim-plugins $out/share/nvim
    mv $out/lib/rosie/extra/emacs/* $out/share/emacs/site-lisp/
    mv $out/lib/rosie/extra/vim $out/share/vim-plugins/rosie
    ln -s $out/share/vim-plugins/rosie $out/share/nvim/site
  '';

  # librosie.so is dlopen'ed , so we disable ELF patching to preserve RUNPATH .
  dontPatchELF = true;

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  buildInputs = [ libbsd readline ];

  meta = with lib; {
    homepage = "https://rosie-lang.org";
    description = "Tools for searching using parsing expression grammars";
    license = licenses.mit;
    maintainers = with maintainers; [ kovirobi ];
    platforms = with platforms; linux ++ darwin;
  };
}
