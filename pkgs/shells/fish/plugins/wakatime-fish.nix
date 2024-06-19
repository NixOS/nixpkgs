{ lib
, wakatime-cli
, buildFishPlugin
, fetchFromGitHub
}:

buildFishPlugin rec {
  pname = "wakatime-fish";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "ik11235";
    repo = "wakatime.fish";
    rev = "v${version}";
    hash = "sha256-Hsr69n4fCvPc64NztgaBZQuR0znkzlL8Uotw9Jf2S1o=";
  };

  preFixup = ''
    substituteInPlace $out/share/fish/vendor_conf.d/wakatime.fish \
      --replace-fail "if type -p wakatime-cli" "if type -p ${lib.getExe wakatime-cli}" \
      --replace-fail "(type -p wakatime-cli)" "${lib.getExe wakatime-cli}"
  '';

  meta = with lib; {
    description = "A fish plugin for wakatime";
    homepage = "https://github.com/ik11235/wakatime.fish";
    license = licenses.mit;
    maintainers = with maintainers; [ ocfox ];
  };
}
