{
  buildBatExtrasPkg,
  less,
}:
buildBatExtrasPkg {
  name = "batpipe";
  dependencies = [ less ];
  meta.description = "Less (and soon bat) preprocessor for viewing more types of files in the terminal";
}
