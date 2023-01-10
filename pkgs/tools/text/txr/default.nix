{ lib,
  stdenv,
  fetchurl,
  coreutils,
  libffi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "txr";
  version = "284";

  src = fetchurl {
    url = "http://www.kylheku.com/cgit/txr/snapshot/txr-${finalAttrs.version}.tar.bz2";
    hash = "sha256-dlAOThO2sJspkSYmR927iu13y3XRSllIGVh7ufu8ROU=";
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

  preCheck = let
    disabledTests = lib.concatStringsSep " " [
      # - tries to set sticky bits
      "tests/018/chmod.tl"
      # - warning: unbound function crypt
      "tests/018/crypt.tl"
    ];
  in ''
    rm ${disabledTests}
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
    homepage = "https://nongnu.org/txr";
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
    changelog = "https://www.kylheku.com/cgit/txr/tree/RELNOTES?h=txr-${finalAttrs.version}";
    license = licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres dtzWill ];
    platforms = platforms.all;
  };
})
