{
  buildBatExtrasPkg,
  less,
}:
buildBatExtrasPkg {
  name = "batpipe";
  dependencies = [ less ];
  meta.description = "less (and soon bat) preprocessor for viewing more types of files in the terminal";
}
