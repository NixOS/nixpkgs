{ lib
, wakatime
, buildFishPlugin
, fetchFromGitHub
}:

buildFishPlugin rec {
  pname = "wakatime-fish";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "ik11235";
    repo = "wakatime.fish";
    rev = "v${version}";
    hash = "sha256-BYDff4OP4Sg5I7p0GviZKSDulx468ePZigigyTdtkqM=";
  };

  preFixup = ''
    substituteInPlace $out/share/fish/vendor_conf.d/wakatime.fish \
      --replace "if type -p wakatime" "if type -p ${lib.getExe wakatime}" \
      --replace "(type -p wakatime)" "${lib.getExe wakatime}"
  '';

  meta = with lib; {
    description = "A fish plugin for wakatime";
    homepage = "https://github.com/ik11235/wakatime.fish";
    license = licenses.mit;
    maintainers = with maintainers; [ ocfox ];
  };
}
