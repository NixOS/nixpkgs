{ stdenv, fetchurl, runCommand, gcc, zlib }:

let
  name = "ccache-${version}";
  version = "3.2.3";
  sha256 = "03k0fvblwqb80zwdgas8a5fjrwvghgsn587wp3lfr0jr8gy1817c";

  ccache =
stdenv.mkDerivation {
  inherit name;
  src = fetchurl {
    inherit sha256;
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
      '');
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = http://ccache.samba.org/;
    downloadPage = https://ccache.samba.org/download.html;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nckx ];
  };
};
in
ccache
