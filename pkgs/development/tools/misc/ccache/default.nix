{ stdenv, fetchurl, fetchpatch, runCommand, zlib }:

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

  doCheck = !stdenv.isDarwin;

  passthru = let
      cc = stdenv.cc.cc;
      ccname = if stdenv.cc.cc.isClang or false then "clang" else "gcc";
      cxxname = if stdenv.cc.cc.isClang or false then "clang++" else "g++";
    in {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = extraConfig: stdenv.mkDerivation rec {
      name = "ccache-links";
      passthru = {
        inherit (cc) isGNU isClang;
      };
      inherit (cc) lib;
      buildCommand = ''
        mkdir -p $out/bin
        if [ -x "${cc}/bin/${ccname}" ]; then
          cat > $out/bin/${ccname} << EOF
          #!/bin/sh
          ${extraConfig}
          exec ${ccache}/bin/ccache ${cc}/bin/${ccname} "\$@"
        EOF
          chmod +x $out/bin/${ccname}
        fi
        if [ -x "${cc}/bin/${cxxname}" ]; then
          cat > $out/bin/${cxxname} << EOF
          #!/bin/sh
          ${extraConfig}
          exec ${ccache}/bin/ccache ${cc}/bin/${cxxname} "\$@"
        EOF
          chmod +x $out/bin/${cxxname}
        fi
        for executable in $(ls ${cc}/bin); do
          if [ ! -x "$out/bin/$executable" ]; then
            ln -s ${cc}/bin/$executable $out/bin/$executable
          fi
        done
        for file in $(ls ${cc} | grep -vw bin); do
          ln -s ${cc}/$file $out/$file
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
    platforms = platforms.unix;
  };
};
in ccache
