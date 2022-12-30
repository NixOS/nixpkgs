{ lib,
  stdenv,
  fetchurl,
  coreutils,
  libffi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "txr";
  version = "283";

  src = fetchurl {
    url = "http://www.kylheku.com/cgit/txr/snapshot/txr-${finalAttrs.version}.tar.bz2";
    hash = "sha256-2TnwxHAiiWEytHpKXrEwQ+ajq19f0lv7ss842kkPs4Y=";
  };

  buildInputs = [ libffi ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "tests";

  postPatch = ''
    substituteInPlace tests/017/realpath.tl --replace /usr/bin /bin
    substituteInPlace tests/017/realpath.expected --replace /usr/bin /bin

    substituteInPlace tests/018/process.tl --replace /usr/bin/env ${lib.getBin coreutils}/bin/env
  '';

  # Remove failing tests -- 018/chmod tries setting sticky bit
  preCheck = ''
    rm -rf tests/018/chmod*
  '';

  # TODO: ship vim plugin separately?
  postInstall = ''
    mkdir -p $out/share/vim-plugins/txr/{syntax,ftdetect}

    cp {tl,txr}.vim $out/share/vim-plugins/txr/syntax/

    cat > $out/share/vim-plugins/txr/ftdetect/txr.vim <<EOF
      au BufRead,BufNewFile *.txr set filetype=txr | set lisp
      au BufRead,BufNewFile *.tl,*.tlo set filetype=tl | set lisp
    EOF
  '';

  meta = with lib; {
    homepage = "http://nongnu.org/txr";
    description = "An Original, New Programming Language for Convenient Data Munging";
    longDescription = ''
      TXR is a general-purpose, multi-paradigm programming language. It
      comprises two languages integrated into a single tool: a text scanning and
      extraction language referred to as the TXR Pattern Language (sometimes
      just "TXR"), and a general-purpose dialect of Lisp called TXR Lisp.

      TXR can be used for everything from "one liner" data transformation tasks
      at the command line, to data scanning and extracting scripts, to full
      application development in a wide range of areas.
    '';
    license = licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres dtzWill ];
    platforms = platforms.all;
  };
})
