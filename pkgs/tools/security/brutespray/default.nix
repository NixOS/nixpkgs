{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  makeWrapper,
  medusa,
}:

stdenv.mkDerivation rec {
  pname = "brutespray";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "x90skysn3k";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-O9HOsj0R6oHI7jjG4FBqbrSAQSVomgeD7tyPDNCNmIo=";
  };

  postPatch = ''
    substituteInPlace brutespray.py \
      --replace "/usr/share/brutespray" "$out/share/brutespray"
  '';

  dontBuild = true;
  nativeBuildInputs = [
    python3.pkgs.wrapPython
    makeWrapper
  ];
  buildInputs = [ python3 ];

  installPhase = ''
    install -Dm0755 brutespray.py $out/bin/brutespray
    patchShebangs $out/bin
    patchPythonScript $out/bin/brutespray
    wrapProgram $out/bin/brutespray \
      --prefix PATH : ${lib.makeBinPath [ medusa ]}

    mkdir -p $out/share/brutespray
    cp -r wordlist/ $out/share/brutespray/wordlist
  '';

  meta = with lib; {
    homepage = "https://github.com/x90skysn3k/brutespray";
    description = "Tool to do brute-forcing from Nmap output";
    mainProgram = "brutespray";
    longDescription = ''
      This tool automatically attempts default credentials on found services
      directly from Nmap output.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
