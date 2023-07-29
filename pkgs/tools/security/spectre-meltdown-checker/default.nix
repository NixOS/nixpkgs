{ lib, stdenv, fetchFromGitHub, makeWrapper, coreutils, binutils-unwrapped }:

stdenv.mkDerivation rec {
  pname = "spectre-meltdown-checker";
  version = "0.46";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
    rev = "v${version}";
    sha256 = "sha256-M4ngdtp2esZ+CSqZAiAeOnKtaK8Ra+TmQfMsr5q5gkg=";
  };

  prePatch = ''
    substituteInPlace spectre-meltdown-checker.sh \
      --replace /bin/echo ${coreutils}/bin/echo
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = with lib; ''
    runHook preInstall

    install -Dm755 spectre-meltdown-checker.sh $out/bin/spectre-meltdown-checker
    wrapProgram $out/bin/spectre-meltdown-checker \
      --prefix PATH : ${makeBinPath [ binutils-unwrapped ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Spectre & Meltdown vulnerability/mitigation checker for Linux";
    homepage = "https://github.com/speed47/spectre-meltdown-checker";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
