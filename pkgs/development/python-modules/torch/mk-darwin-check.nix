{
  libraries,
  python,
  writeShellApplication,
}:
writeShellApplication {
  name = "test-torch-darwin";
  runtimeInputs = [ (python.withPackages libraries) ];
  text = ''
    python ${./darwin-check.py}
  '';
}
