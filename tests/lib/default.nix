{ pkgs }:
rec {
  inherit (pkgs) lib runCommand makeSetupHook;
  maybeCall = value: args:
    if builtins.isFunction value then (value args) else value;

  withDBus = makeSetupHook {
    substitutions = {
      inherit (pkgs) dbus;
    };
  } ./dbus.sh;
  withX = { display ? 27, dpi ? 150, geometry ? "800x600" }:
    makeSetupHook {
      substitutions = {
        inherit (pkgs) xdummy;
        inherit (pkgs.xorg) xrandr xrdb;
        inherit display geometry dpi;
      };
    } ./x.sh;
  withRatpoison = xArgs: makeSetupHook {
    deps = [pkgs.ratpoison];
    substitutions = {
      inherit (pkgs) ratpoison;
      withX = (withX xArgs);
    };
  } ./ratpoison.sh;
  withFonts = fonts: makeSetupHook {} (pkgs.writeText "font-hook.sh" ''
    export FONTCONFIG_FILE="${pkgs.makeFontsConf {
      fontDirectories = maybeCall fonts pkgs;
    }}"
  '');
  withHome = makeSetupHook {} (pkgs.writeText "home-hook.sh" ''
    export HOME="$PWD/home"; mkdir "$HOME"
  '');

  fmbtHeader = ''
    import os
    import sys
    import fmbtx11
    import time

    screen = fmbtx11.Screen()
    screen.refreshScreenshot()
  '';
  fmbtRun = code: ''
    "${lib.getBin pkgs.fmbt}/bin/fmbt-python" \
      -c ${lib.escapeShellArg fmbtHeader}${lib.escapeShellArg code}
  '';

  checkAllExecutables = package: {
    flags ? "--version", outputRegexp ? "."
    , skipRegexp ? "^$", includeRegexp ? ".*"
    , checkExitCode ? "test $exitCode -lt 126 || test $exitCode -gt 160"
  }: 
  runCommand "${package.name}-executable-check" {} ''
    mkdir "$out"
    for i in "${package}"/bin/*; do
      if echo "$i" | grep -E ${lib.escapeShellArg includeRegexp} |
            grep -Ev ${lib.escapeShellArg skipRegexp}; then
        ${ if outputRegexp != null then ''
          "$i" ${flags} | grep -E ${lib.escapeShellArg outputRegexp} |
            tee "$out/$(basename "$i")"
        '' else ""}
        ${ if checkExitCode != null then ''
          exitCode="$(( "$i" ${flags} &> /dev/null && echo 0; ) || echo $?; )"
          echo exit code: $exitCode
          ${checkExitCode}
        '' else ""}
      fi
    done
  '';
}
