{ stdenv, fetchurl, fetchpatch, runCommand, zlib, makeWrapper }:

let ccache = stdenv.mkDerivation rec {
  name = "ccache-${version}";
  version = "3.3.4";

  src = fetchurl {
    sha256 = "0ks0vk408mdppfbk8v38p46fqx3p30r9a9cwiia43373i7rmpw94";
    url = "mirror://samba/ccache/${name}.tar.xz";
  };

  buildInputs = [ zlib ];

  # non to be fail on filesystems with unconventional blocksizes (zfs on Hydra?)
  patches = [ ./skip-fs-dependent-test.patch ];

  postPatch = ''
    substituteInPlace Makefile.in --replace 'objs) $(extra_libs)' 'objs)'
  '';

  doCheck = !stdenv.isDarwin;

  passthru = let
      unwrappedCC = stdenv.cc.cc;
    in {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = extraConfig: stdenv.mkDerivation rec {
      name = "ccache-links";
      passthru = {
        isClang = unwrappedCC.isClang or false;
        isGNU = unwrappedCC.isGNU or false;
      };
      inherit (unwrappedCC) lib;
      nativeBuildInputs = [ makeWrapper ];
      buildCommand = ''
        mkdir -p $out/bin

        wrap() {
          local cname="$1"
          if [ -x "${unwrappedCC}/bin/$cname" ]; then
            makeWrapper ${ccache}/bin/ccache $out/bin/$cname \
              --run ${stdenv.lib.escapeShellArg extraConfig} \
              --add-flags ${unwrappedCC}/bin/$cname
          fi
        }

        wrap cc
        wrap c++
        wrap gcc
        wrap g++
        wrap clang
        wrap clang++

        for executable in $(ls ${unwrappedCC}/bin); do
          if [ ! -x "$out/bin/$executable" ]; then
            ln -s ${unwrappedCC}/bin/$executable $out/bin/$executable
          fi
        done
        for file in $(ls ${unwrappedCC} | grep -vw bin); do
          ln -s ${unwrappedCC}/$file $out/$file
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
