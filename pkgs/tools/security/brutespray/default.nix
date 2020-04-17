{ stdenv, python3, fetchFromGitHub, makeWrapper, medusa }:

stdenv.mkDerivation rec {
  pname = "brutespray";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = pname;
    rev = "brutespray-${version}";
    sha256 = "1rj8fkq1xz4ph1pmldphlsa25mg6xl7i7dranb0qjx00jhfxjxjh";
  };

  postPatch = ''
    substituteInPlace brutespray.py \
      --replace "/usr/share/brutespray" "$out/share/brutespray"
  '';

  dontBuild = true;
  nativeBuildInputs = [ python3.pkgs.wrapPython makeWrapper ];
  buildInputs = [ python3 ];

  installPhase = ''
    install -Dm0755 brutespray.py $out/bin/brutespray
    patchShebangs $out/bin
    patchPythonScript $out/bin/brutespray
    wrapProgram $out/bin/brutespray \
      --prefix PATH : ${stdenv.lib.makeBinPath [ medusa ]}

    mkdir -p $out/share/brutespray
    cp -r wordlist/ $out/share/brutespray/wordlist
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/x90skysn3k/brutespray";
    description = "Brute-Forcing from Nmap output - Automatically attempts default creds on found services";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
