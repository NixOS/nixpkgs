{
  version = "4.5.1-stable";
  hash = "sha256-8iMhn40y7aVL6Xjvo34ZtfygJYWwDmCnTxUJcV3AQCI=";
  default = {
    exportTemplatesHash = "sha256-GZivN/E4doTiwhHNtIPa9JL8ZNxrEglr3c3KJbaRDIY=";
  };
  mono = {
    exportTemplatesHash = "sha256-xCVjMGG7SfQ5C9zs4rnOaLOwvjxxCVtAZE2PbxexFG4=";
    nugetDeps = ./deps.json;
  };
}
