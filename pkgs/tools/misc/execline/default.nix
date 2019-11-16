{ lib, skawarePackages
# for execlineb-with-builtins
, coreutils, gnugrep, writeScriptBin, runCommand, runCommandCC
# Whether to wrap bin/execlineb to have the execline tools on its PATH.
, execlineb-with-builtins ? true
}:

with skawarePackages;

let
  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  execline =
    buildPackage {
      pname = "execline";
      version = "2.5.3.0";
      sha256 = "0czdrv9m8mnx94nf28dafij6z03k4mbhbs6hccfaardfd5l5q805";

      description = "A small scripting language, to be used in place of a shell in non-interactive scripts";

      inherit outputs;

      # TODO: nsss support
      configureFlags = [
        "--libdir=\${lib}/lib"
        "--dynlibdir=\${lib}/lib"
        "--bindir=\${bin}/bin"
        "--includedir=\${dev}/include"
        "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
        "--with-include=${skalibs.dev}/include"
        "--with-lib=${skalibs.lib}/lib"
        "--with-dynlib=${skalibs.lib}/lib"
      ];

      postInstall = ''
        # remove all execline executables from build directory
        rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
        rm libexecline.*

        mv doc $doc/share/doc/execline/html
        mv examples $doc/share/doc/execline/examples
      '';

    };

  # A wrapper around execlineb, which provides all execline
  # tools on `execlineb`’s PATH.
  # It is implemented as a C script, because on non-Linux,
  # nested shebang lines are not supported.
  execlineb-with-builtins-drv = runCommandCC "execlineb" {} ''
    mkdir -p $out/bin
    cc \
      -O \
      -Wall -Wpedantic \
      -D 'EXECLINEB_PATH()="${execline}/bin/execlineb"' \
      -D 'EXECLINE_BIN_PATH()="${execline}/bin"' \
      -I "${skalibs.dev}/include" \
      -L "${skalibs.lib}/lib" \
      -l"skarnet" \
      -o "$out/bin/execlineb" \
      ${./execlineb-wrapper.c}
  '';


  # the original execline package, with bin/execlineb overwritten
  execline-with-builtins = runCommand "my-execline"
    (execline.drvAttrs // {
      preferLocalBuild = true;
      allowSubstitutes = false;
    })
    # copy every output and just overwrite the execlineb binary in $bin
    ''
      ${lib.concatMapStringsSep "\n"
        (output: ''
          cp -r ${execline.${output}} "''$${output}"
          chmod --recursive +w "''$${output}"
        '')
        outputs}
      install ${execlineb-with-builtins-drv}/bin/execlineb $bin/bin/execlineb
    '';

in
  if execlineb-with-builtins
  then execline-with-builtins
  else execline
