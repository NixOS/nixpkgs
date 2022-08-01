{ lib
, stdenvNoCC
, fetchFromGitHub
, python3
, sage
, yafu
, makeWrapper
}:

let
  pythonEnv = python3.withPackages (p: with p; [
    six
    sympy
    cryptography
    urllib3
    requests
    gmpy
    gmpy2
    pycryptodome
    tqdm
    z3
    bitarray
    egcd
  ]);
in
stdenvNoCC.mkDerivation rec {
  pname = "rsactftool";
  version = "unstable-2022-07-28";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "ea8736ee3f8796dda14f309553bae24313c8d51c";
    sha256 = "ca+ijM6jOv19Nh404LdoLfE2szq886dY/L7s566aDDc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -r $src $out/share/rsactftool
    makeWrapper ${pythonEnv.interpreter} $out/bin/RsaCtfTool.py \
      --add-flags $out/share/rsactftool/RsaCtfTool.py \
      --prefix PATH : ${lib.makeBinPath [ sage yafu ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Retreive private key from weak public key and/or uncipher data";
    homepage = "https://github.com/RsaCtfTool/RsaCtfTool";
    mainProgram = "RsaCtfTool.py";
    license = licenses.beerware;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
