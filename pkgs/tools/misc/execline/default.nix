{ lib, skawarePackages
# for execlineb-with-builtins
, coreutils, gnugrep, writeScriptBin, runCommand
# Whether to wrap bin/execlineb to have the execline tools on its PATH.
, execlineb-with-builtins ? true
}:

with skawarePackages;

let
  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  execline =
    buildPackage {
      pname = "execline";
      version = "2.5.1.0";
      sha256 = "0xr6yb50wm6amj1wc7jmxyv7hvlx2ypbnww1vc288j275625d9xi";

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

  # a wrapper around execlineb, which provides all execline
  # tools on `execlineb`’s PATH.
  execlineb-with-builtins-drv =
    let eldir = "${execline}/bin";
    in writeScriptBin "execlineb" ''
      #!${eldir}/execlineb -s0
      # appends the execlineb bin dir to PATH if not yet in PATH
      ${eldir}/define eldir ${eldir}
      ''${eldir}/ifelse
      {
        # since this is nix, we can grep for the execline drv hash in PATH
        # to see whether it’s already in there
        ''${eldir}/pipeline
        { ${coreutils}/bin/printenv PATH }
        ${gnugrep}/bin/grep --quiet "${eldir}"
      }
      # it’s there already
      { ''${eldir}/execlineb $@ }
      # not there yet, add it
      ''${eldir}/importas oldpath PATH
      ''${eldir}/export PATH "''${eldir}:''${oldpath}"
      ''${eldir}/execlineb $@
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
