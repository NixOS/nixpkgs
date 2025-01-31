{ substituteAll, runtimeShell }:

substituteAll {
  name = "xargs-j";
  shell = runtimeShell;
  src = ./xargs-j.sh;
  dir = "bin";
  isExecutable = true;
}
