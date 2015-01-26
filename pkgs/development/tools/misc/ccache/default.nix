{stdenv, fetchurl, runCommand, gcc, zlib}:

let
  ccache =
stdenv.mkDerivation {
  name = "ccache-3.2.1";
  src = fetchurl {
    url = http://samba.org/ftp/ccache/ccache-3.2.1.tar.xz;
    sha256 = "17dxb0adha2bqzb2r8rcc3kl9mk7y6vrvlh181liivrc3m7g6al7";
  };

  buildInputs = [ zlib ];

  passthru = {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = extraConfig : (runCommand "ccache-links" { }
      ''
        mkdir -p $out/bin
        if [ -x "${gcc.gcc}/bin/gcc" ]; then
          cat > $out/bin/gcc << EOF
          #!/bin/sh
          ${extraConfig}
          exec ${ccache}/bin/ccache ${gcc.gcc}/bin/gcc "\$@"
        EOF
          chmod +x $out/bin/gcc
        fi
        if [ -x "${gcc.gcc}/bin/g++" ]; then
          cat > $out/bin/g++ << EOF
          #!/bin/sh
          ${extraConfig}
          exec ${ccache}/bin/ccache ${gcc.gcc}/bin/g++ "\$@"
        EOF
          chmod +x $out/bin/g++
        fi
      '');
  };

  meta = with stdenv.lib; {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = http://ccache.samba.org/;
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ nckx ];
  };
};
in
ccache
