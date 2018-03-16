# an example helper to try running all the executables of a package
# 
# flags: pass these flags to each executable
# outputRegexp: a regexp to validate the output; must match at least one line
# skipRegexp, includeRegexp: the regexps to select the executables to test
# checkExitCode: shell code to verify that the exit code is acceptable;
#     default is to check that the exit code is non-special
{ pkgs ? import ../../default.nix {} 
, package
, flags ? "--version", outputRegexp ? "."
, skipRegexp ? "^$", includeRegexp ? ".*"
, checkExitCode ? "test $exitCode -lt 126 || test $exitCode -gt 160"
, meta ? {}
}:
let _package = pkgs.lib.optCall package pkgs; in
pkgs.runCommand "${_package.name}-executable-check" {
  meta = pkgs.lib.recursiveUpdate {
    description = "Try running executables in the ${_package.name} output";
    inherit (_package.meta) platforms;
  } meta;
} ''
  mkdir "$out"
  for i in "${_package}"/bin/*; do
    if echo "$i" | grep -E ${pkgs.lib.escapeShellArg includeRegexp} |
          grep -Ev ${pkgs.lib.escapeShellArg skipRegexp}; then
      ${ if outputRegexp != null then ''
        "$i" ${flags} | grep -E ${pkgs.lib.escapeShellArg outputRegexp} |
          tee "$out/$(basename "$i")"
      '' else ""}
      ${ if checkExitCode != null then ''
        exitCode="$(( "$i" ${flags} &> /dev/null && echo 0; ) || echo $?; )"
        echo exit code: $exitCode
        ${checkExitCode}
      '' else ""}
    fi
  done
''
