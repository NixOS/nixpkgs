{stdenv, fetchurl, runCommand, gcc, zlib}:

let
  ccache =
stdenv.mkDerivation {
  name = "ccache-3.1.7";
  src = fetchurl {
    url = http://samba.org/ftp/ccache/ccache-3.1.7.tar.gz;
    sha256 = "04ax6ks49b6rn57hx4v9wbvmsfmw6ipn0wyfqwhh4lzw70flv3r7";
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
    description = "ccache, a tool that caches compilation results.";
    homepage = http://ccache.samba.org/;
    license = "GPL";
  };
};
in
ccache
