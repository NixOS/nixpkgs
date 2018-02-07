{ lib, python3Packages }:
python3Packages.buildPythonApplication rec {
  version = "0.44.0";
  pname = "meson";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1rpqp9iwbvr4xvfdh3iyfh1ha274hbb66jbgw3pa5a73x4d4ilqn";
  };

  postFixup = ''
    pushd $out/bin
    # undo shell wrapper as meson tools are called with python
    for i in *; do
      mv ".$i-wrapped" "$i"
    done
    popd
  '';

  patches = [
    # Unlike libtool, vanilla Meson does not pass any information
    # about the path library will be installed to to g-ir-scanner,
    # breaking the GIR when path other than ${!outputLib}/lib is used.
    # We patch Meson to add a --fallback-library-path argument with
    # library install_dir to g-ir-scanner.
    ./gir-fallback-path.patch
  ];

  postPatch = ''
    sed -i -e 's|e.fix_rpath(install_rpath)||' mesonbuild/scripts/meson_install.py
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = http://mesonbuild.com;
    description = "SCons-like build system that use python as a front-end language and Ninja as a building backend";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbe rasendubi ];
    platforms = platforms.all;
  };
}
