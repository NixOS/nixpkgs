{
  local texFolder
  local texFolders
  texFolders=(@texFolders@)
  for texFolder in "${texFolders[@]}" ; do
    addToSearchPath TEXMFAUXTREES "$texFolder//"
  done
}
export TEXMFAUXTREES
