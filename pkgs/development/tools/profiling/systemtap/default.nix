{ lib, fetchgit, pkg-config, gettext, runCommand, makeWrapper
, cpio, elfutils, kernel, gnumake, python3
}:

let
  ## fetchgit info
  url = "git://sourceware.org/git/systemtap.git";
  rev = "release-${version}";
  sha256 = "sha256-UiUMoqdfkk6mzaPGctpQW3dvOWKhNBNuScJ5BpCykVg=";
  version = "4.8";

  inherit (kernel) stdenv;

  ## stap binaries
  stapBuild = stdenv.mkDerivation {
    pname = "systemtap";
    inherit version;
    src = fetchgit { inherit url rev sha256; };
    nativeBuildInputs = [ pkg-config cpio python3 python3.pkgs.setuptools ];
    buildInputs = [ elfutils gettext ];
    enableParallelBuilding = true;
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=deprecated-declarations" ]; # Needed with GCC 12
  };

  pypkgs = with python3.pkgs; makePythonPath [ pyparsing ];

in runCommand "systemtap-${kernel.version}-${version}" {
  inherit stapBuild;
  nativeBuildInputs = [ makeWrapper ];
  meta = {
    homepage = "https://sourceware.org/systemtap/";
    description = "Provides a scripting language for instrumentation on a live kernel plus user-space";
    license = lib.licenses.gpl2;
    platforms = lib.systems.inspect.patterns.isGnu;
  };
} ''
  mkdir -p $out/bin
  for bin in $stapBuild/bin/*; do
    ln -s $bin $out/bin
  done
  rm $out/bin/stap $out/bin/dtrace
  makeWrapper $stapBuild/bin/stap $out/bin/stap \
    --add-flags "-r ${kernel.dev}" \
    --prefix PATH : ${lib.makeBinPath [ stdenv.cc.cc stdenv.cc.bintools elfutils gnumake ]}
  makeWrapper $stapBuild/bin/dtrace $out/bin/dtrace \
    --prefix PYTHONPATH : ${pypkgs}
''
