# documentation see ../lib/strings-with-deps2.nix
# coverts Michael Raskin builder script snippets so that they can be used with createScript from strings-with-deps2.nix

raskin_defs : rec {

  defAddToSearchPath = { 
    name = "defAddToSearchPath";
    value = raskin_defs.defAddToSearchPath.text;
    dependencies = [ "defNest" ];
  };
  defNest = { 
    name = "defNest";
    value = raskin_defs.defNest.text;
  };
  minInit = { 
    name = "minInit";
    value = raskin_defs.minInit.text;
    dependencies = [ "defNest" "defAddToSearchPath" ];
  };

  addInputs = { 
    name = "addInputs";
    value = raskin_defs.addInputs.text;
    dependencies = [ "minInit" ];
  };

  toSrcDir = s : { 
    name = "toSrcDir";
    value = (raskin_defs.toSrcDir s).text;
    dependencies = [ "minInit" ];
  };

  doConfigure = { 
    name = "doConfigure";
    value = raskin_defs.doConfigure.text;
    dependencies = [ "minInit" "addInputs" "doUnpack" ];
  };

  doAutotools = { 
    name = "doAutotools";
    value = raskin_defs.doAutotools.text;
    dependencies = [ "minInit" "addInputs" "doUnpack" ];
  };

  doMake = { 
    name = "doMake";
    value = raskin_defs.doMake.text;
    dependencies = [ "minInit" "addInputs" "doUnpack" ];
  };

# more have to be added here! 
}
