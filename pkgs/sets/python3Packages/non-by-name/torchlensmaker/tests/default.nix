{
  runCommand,
  torchlensmaker,
}:

runCommand "test-torchlensmaker"
  {
    nativeBuildInputs = [
      torchlensmaker.pyEnv
    ];
  }
  ''
    python -P ${./landscape.py}
    mv landscape.json $out
  ''
