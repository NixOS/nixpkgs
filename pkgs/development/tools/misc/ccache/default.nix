{ stdenv, fetchurl, fetchpatch, runCommand, gcc, zlib }:

let ccache = stdenv.mkDerivation rec {
  name = "ccache-${version}";
  version = "3.2.4";

  src = fetchurl {
    sha256 = "0pga3hvd80f2p7mz88jmmbwzxh4vn5ihyjx5f6na8y2fclzsjg8w";
    url = "mirror://samba/ccache/${name}.tar.xz";
  };

  patches = [
    (fetchpatch {
      sha256 = "1gwnxx1w2nx1szi0v5vgwcx9i23pxygkqqnrawhal68qgz5c34wh";
      name = "dont-update-manifest-in-readonly-modes.patch";
      # The primary git.samba.org doesn't seem to like our curl much...
      url = "https://github.com/jrosdahl/ccache/commit/a7ab503f07e31ebeaaec34fbaa30e264308a299d.patch";
    })
  ];

  buildInputs = [ zlib ];

  postPatch = ''
    substituteInPlace Makefile.in --replace 'objs) $(extra_libs)' 'objs)'
  '';

  doCheck = true;

  passthru = {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = extraConfig: (runCommand "ccache-links"
      { passthru.gcc = gcc; passthru.isGNU = true; }
      ''
        mkdir -p $out/bin
        if [ -x "${gcc.cc}/bin/gcc" ]; then
          cat > $out/bin/gcc << EOF
          #!/bin/sh
          ${extraConfig}
          exec ${ccache}/bin/ccache ${gcc.cc}/bin/gcc "\$@"
        EOF
          chmod +x $out/bin/gcc
        fi
        if [ -x "${gcc.cc}/bin/g++" ]; then
          cat > $out/bin/g++ << EOF
          #!/bin/sh
          ${extraConfig}
          exec ${ccache}/bin/ccache ${gcc.cc}/bin/g++ "\$@"
        EOF
          chmod +x $out/bin/g++
        fi
        for executable in $(ls ${gcc.cc}/bin); do
          if [ ! -x "$out/bin/$executable" ]; then
            ln -s ${gcc.cc}/bin/$executable $out/bin/$executable
          fi
        done
        for file in $(ls ${gcc.cc} | grep -vw bin); do
          ln -s ${gcc.cc}/$file $out/$file
        done
      '');
  };

  meta = with stdenv.lib; {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = http://ccache.samba.org/;
    downloadPage = https://ccache.samba.org/download.html;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nckx ];
  };
};
in ccache
