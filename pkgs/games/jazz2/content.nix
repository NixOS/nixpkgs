{ jazz2
, lib
, runCommand
}:

runCommand "jazz2-content"
{
  inherit (jazz2) version src;

  preferLocalBuild = true;

  meta = with lib; {
    description = "Assets needed for jazz2";
    homepage = "https://github.com/deathkiller/jazz2-native";
    license = licenses.gpl3;
    maintainers = with maintainers; [ surfaceflinger ];
  };
} ''
  cp -r $src/Content $out
''
