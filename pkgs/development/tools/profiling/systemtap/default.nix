{ fetchgit, pkgconfig, gettext, runCommand, makeWrapper
, elfutils, kernel, gnumake, python2, python2Packages
}:

let
  ## fetchgit info
  url = git://sourceware.org/git/systemtap.git;
  rev = "4051c70c9318c837981384cbb23f3e9eb1bd0892";
  sha256 = "0sd8n3j3rishks3gyqj2jyqhps7hmlfjyz8i0w8v98cczhhh04rq";
  version = "2017.10.18";

  inherit (kernel) stdenv;
  inherit (stdenv) lib;

  ## stap binaries
  stapBuild = stdenv.mkDerivation {
    name = "systemtap-${version}";
    src = fetchgit { inherit url rev sha256; };
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ elfutils gettext python2 python2Packages.setuptools ];
    # FIXME: Workaround for bug in kbuild, where quoted -I"/foo" flags would get mangled in out-of-tree kbuild dirs
    postPatch = ''
      substituteInPlace buildrun.cxx --replace \
        'o << "EXTRA_CFLAGS += -I\"" << s.runtime_path << "\"" << endl;' \
        'o << "EXTRA_CFLAGS += -I" << s.runtime_path << endl;'
    '';
    enableParallelBuilding = true;
  };

  ## a kernel build dir as expected by systemtap
  kernelBuildDir = runCommand "kbuild-${kernel.version}-merged" { } ''
    mkdir -p $out
    for f in \
        ${kernel}/System.map \
        ${kernel.dev}/vmlinux \
        ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/{*,.*}
    do
      ln -s $(readlink -f $f) $out
    done
  '';

  pypkgs = with python2Packages; makePythonPath [ pyparsing ];

in runCommand "systemtap-${kernel.version}-${version}" {
  inherit stapBuild kernelBuildDir;
  buildInputs = [ makeWrapper ];
  meta = {
    homepage = https://sourceware.org/systemtap/;
    repositories.git = url;
    description = "Provides a scripting language for instrumentation on a live kernel plus user-space";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
} ''
  mkdir -p $out/bin
  for bin in $stapBuild/bin/*; do # hello emacs */
    ln -s $bin $out/bin
  done
  rm $out/bin/stap $out/bin/dtrace
  makeWrapper $stapBuild/bin/stap $out/bin/stap \
    --add-flags "-r $kernelBuildDir" \
    --prefix PATH : ${lib.makeBinPath [ stdenv.cc.cc stdenv.cc.bintools elfutils gnumake ]}
  makeWrapper $stapBuild/bin/dtrace $out/bin/dtrace \
    --prefix PYTHONPATH : ${pypkgs}
''
