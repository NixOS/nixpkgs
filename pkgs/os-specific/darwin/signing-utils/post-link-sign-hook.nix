{
  writeTextFile,
  cctools,
  sigtool,
}:

writeTextFile {
  name = "post-link-sign-hook";
  executable = true;

  text = ''
    if [ "$linkerOutput" != "/dev/null" ]; then
      CODESIGN_ALLOCATE=${cctools}/bin/${cctools.targetPrefix}codesign_allocate \
        ${sigtool}/bin/codesign -f -s - "$linkerOutput"
    fi
  '';
}
