{ stdenv, pkgs, cores }:

assert cores != [];

with pkgs.lib;

let

  script = exec: ''
    #!${stdenv.shell}
    nohup sh -c "sleep 1 && pkill -SIGSTOP xbmc" &
    nohup sh -c "${exec} '$@' -f;pkill -SIGCONT xbmc"
  '';
  scriptSh = exec: pkgs.writeScript ("xbmc-"+exec.name) (script exec.path);
  execs = map (core: rec { name = core.core; path = core+"/bin/retroarch-"+name;}) cores;

in

stdenv.mkDerivation rec {
  name = "xbmc-retroarch-advanced-launchers-${version}";
  version = "0.2";

  dontBuild = true;

  buildCommand = ''
    mkdir -p $out/bin
    ${stdenv.lib.concatMapStrings (exec: "ln -s ${scriptSh exec} $out/bin/xbmc-${exec.name};") execs}
  '';

  meta = {
    description = "XBMC retroarch advanced launchers";
    longDescription = ''
      These retroarch launchers are intended to be used with
      anglescry advanced launcher for XBMC since device input is
      caught by both XBMC and the retroarch process.
    '';
    license = stdenv.lib.licenses.gpl3;
  };
}
