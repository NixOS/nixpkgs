{ stdenv, fetchurl, runCommand, gcc, zlib }:

let
  # TODO: find out if there's harm in just using 'rec' instead.
  name = "ccache-${version}";
  version = "3.2.2";
  sha256 = "1jm0qb3h5sypllaiyj81zp6m009vm50hzjnx994ril94kxlrj3ag";

  ccache =
stdenv.mkDerivation {
  inherit name;
  src = fetchurl {
    inherit sha256;
    url = "mirror://samba/ccache/${name}.tar.xz";
  };

  patches = [ ./test-drop-perl-requirement.patch ];

  buildInputs = [ zlib ];

  doCheck = true;

  passthru = {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = extraConfig : (runCommand "ccache-links" { passthru.gcc = gcc; }
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
