{ replaceVarsWith, runtimeShell }:

replaceVarsWith {
  name = "xargs-j";
  src = ./xargs-j.sh;
  dir = "bin";
  isExecutable = true;

  replacements = {
    inherit runtimeShell;
  };
}
