# This is essentially for mkRunline, but if it becomes useful to have
# default arguments for something else, this is where they should go.
{
  debug = {
    enable = false;
    suspend = false;
    port = "18001";
    # host = "127.0.0.1"; #TODO for implementation when ghidra version is updated
    };

  args = {
    name = "Ghidra";
    maxMemory = "";
    vmArgs = "";
    class = "ghidra.GhidraRun";
    extraArgs = "";
    enableUserShellArgs = true;

    #Convenience, see tests/headless-00.nix for an example.
    headless = {
      name = "Ghidra-Headless";
      class = "ghidra.app.util.headless.AnalyzeHeadless";
      };
    };
  }
