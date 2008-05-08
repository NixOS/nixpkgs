{stdenv, module_init_tools, modules}:

stdenv.mkDerivation {
  name = "kernel-modules";

  buildCommand = ''
    ensureDir $out/lib/modules
    cd $out/
    modules="${toString modules}"
    for i in $modules; do 
        cp -rfs $i/* .
        chmod -R u+w .
        v=$(cd $i/lib/modules && ls -d *)
        if test -n "$version" -a "$v" != "$version"; then
            echo "kernel version mismatch: $version versus $v (in the module paths $modules)";
            exit 1
        fi
        version=$v
    done
    echo "kernel version is $version"
    rm -rf nix-support
    cd lib/modules/
    rm */modules.*
    #  linux-* will pass the new kernel version to depmod to take rather than `uname -r` (see man page)
    MODULE_DIR=$PWD/ ${module_init_tools}/sbin/depmod -a $(basename lib/modules/2.*)
    cd $out/
  '';
}
