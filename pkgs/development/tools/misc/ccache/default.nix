{ stdenv, fetchurl, fetchpatch, runCommand, gcc, zlib }:

let ccache = stdenv.mkDerivation rec {
  name = "ccache-${version}";
  version = "3.2.5";

  src = fetchurl {
    sha256 = "11db1g109g0g5si0s50yd99ja5f8j4asxb081clvx78r9d9i2w0i";
    url = "mirror://samba/ccache/${name}.tar.xz";
  };

  buildInputs = [ zlib ];

  postPatch = ''
    substituteInPlace Makefile.in --replace 'objs) $(extra_libs)' 'objs)'
  '';

  doCheck = true;

  passthru = {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = extraConfig: stdenv.mkDerivation rec {
      name = "ccache-links";
      passthru = {
        inherit gcc;
        isGNU = true;
      };
      inherit (gcc.cc) lib;
      buildCommand = ''
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
      '';
    };
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
