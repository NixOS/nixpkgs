{stdenv, fetchurl, runCommand, gcc, zlib}:

let
  ccache =
stdenv.mkDerivation {
  name = "ccache-3.1.9";
  src = fetchurl {
    url = http://samba.org/ftp/ccache/ccache-3.1.9.tar.gz;
    sha256 = "0ixlxqv1xyacwgg0k9b4a6by07c7k75y0xbr8dp76jvyada0c9x2";
  };

  buildInputs = [ zlib ];

  passthru = {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = extraConfig : (runCommand "ccache-links"
        { inherit (gcc) langC langCC; }
      ''
        mkdir -p $out/bin
        if [ $langC -eq 1 ]; then
          cat > $out/bin/gcc << EOF
          #!/bin/sh
          ${extraConfig}
          exec ${ccache}/bin/ccache ${gcc.gcc}/bin/gcc "\$@"
        EOF
          chmod +x $out/bin/gcc
        fi
        if [ $langCC -eq 1 ]; then
          cat > $out/bin/g++ << EOF
          #!/bin/sh
          ${extraConfig}
          exec ${ccache}/bin/ccache ${gcc.gcc}/bin/g++ "\$@"
        EOF
          chmod +x $out/bin/g++
        fi
      '');
  };

  meta = {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = http://ccache.samba.org/;
    license = "GPL";
  };
};
in
ccache
