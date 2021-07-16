{ fetchFromGitHub
, lib
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "SecLists";
  version = "unstable-2020-11-11";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = pname;
    rev = "9f4d672e98a837fb1f3d59095df36b63af6987d1";
    sha256 = "EoLX4LmftkUZXbwGHLigbgC5bj23UL72k4li42YRzSs=";
  };

  installPhase = ''
    mkdir -p $out/share/SecLists
    cp -R Discovery Fuzzing IOCs Miscellaneous Passwords Pattern-Matching Payloads Usernames Web-Shells \
      $out/share/SecLists
    find $out/share/SecLists -name "*.md" -delete
  '';

  meta = with lib; {
    homepage = "https://github.com/danielmiessler/SecLists";
    license = licenses.mit;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
