{ runCommand
, xonsh-unwrapped
, lib
, extraPackages ? (ps: [ ])
}:

let
  xonsh = xonsh-unwrapped;
  inherit (xonsh.passthru) python;

  pythonEnv = python.withPackages (ps: [
    (ps.toPythonModule xonsh)
  ] ++ extraPackages ps);

in
runCommand "${xonsh.pname}-${xonsh.version}"
{
  inherit (xonsh) pname version meta passthru;
} ''
  mkdir -p $out/bin
  for bin in ${lib.getBin xonsh}/bin/*; do
    ln -s ${pythonEnv}/bin/$(basename "$bin") $out/bin/
  done
''
