{ lib
, stdenv
, fetchgit
, libbsd
, readline
}:

stdenv.mkDerivation rec {
  pname = "rosie";
  version = "unstable-2020-01-11";

  src = fetchgit {
    url = "https://gitlab.com/rosie-pattern-language/rosie";
    rev = "670e9027563609ba2ea31e14e2621a1302742795";
    sha256 = "0jc512dbn62a1fniknhbp6q0xa1p7xi3hn5v60is8sy9jgi3afxv";
    fetchSubmodules = true;
  };

  postUnpack = ''
    # The Makefile calls git to update submodules, unless this file exists
    touch ${src.name}/submodules/~~present~~
  '';

  preConfigure = ''
    patchShebangs src/build_info.sh
    # Part of the same Makefile target which calls git to update submodules
    ln -s src submodules/lua/include
  '';

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp $out/share/vim-plugins $out/share/nvim
    mv $out/lib/rosie/extra/extra/emacs/* $out/share/emacs/site-lisp/
    mv $out/lib/rosie/extra/extra/vim $out/share/vim-plugins/rosie
    ln -s $out/share/vim-plugins/rosie $out/share/nvim/site
  '';

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
