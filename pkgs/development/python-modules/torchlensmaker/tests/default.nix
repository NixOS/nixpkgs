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
    python ${./landscape.py}
    mv landscape.json $out
  ''
