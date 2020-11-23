{ fetchFromGitLab
, lib
, stdenv
}:

let
  shared = "rockyou.txt";

in stdenv.mkDerivation rec {
  pname = "rockyou";
  version = "0.3-1kali3";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "wordlists";
    rev = "debian/${version}";
    sha256 = "sha256-viOd8iKLTiHrPF0azICp/F16JrPUfo4kbcGUPD2/cRs=";
  } + "/rockyou.txt.gz";

  unpackCmd = ''
    mkdir src
    gzip -dc ${src} > src/rockyou.txt
  '';

  installPhase = ''
    install -m 444 -D rockyou.txt $out/share/${shared}
  '';

  passthru = { inherit shared; };

  meta = with lib; {
    license = "unknown";
    maintainers = with maintainers; [ pamplemousse ];
  };
}
