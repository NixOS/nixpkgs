{ stdenv, kmod, modules, buildEnv }:

buildEnv {
  name = "kernel-modules";

  paths = modules;

  postBuild =
    ''
      source ${stdenv}/setup

      kernelVersion=$(cd $out/lib/modules && ls -d *)
      if test "$(echo $kernelVersion | wc -w)" != 1; then
         echo "inconsistent kernel versions: $kernelVersion"
         exit 1
      fi

      echo "kernel version is $kernelVersion"

      # Regenerate the depmod map files.  Be sure to pass an explicit
      # kernel version number, otherwise depmod will use `uname -r'.
      if test -w $out/lib/modules/$kernelVersion; then
          rm -f $out/lib/modules/$kernelVersion/modules.*
          ${kmod}/bin/depmod -b $out -a $kernelVersion
      fi
    '';
}
