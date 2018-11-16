{ stdenv, fetchFromGitHub, makeWrapper, coreutils, binutils-unwrapped }:

stdenv.mkDerivation rec {
  name = "spectre-meltdown-checker-${version}";
  version = "0.40";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
    rev = "v${version}";
    sha256 = "0lhykc2andl0611bbs9b5dzp7c753crppvir2i7aw6bgwis23gjs";
  };

  prePatch = ''
    substituteInPlace spectre-meltdown-checker.sh \
      --replace /bin/echo ${coreutils}/bin/echo
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = with stdenv.lib; ''
    runHook preInstall

    install -Dm755 spectre-meltdown-checker.sh $out/bin/spectre-meltdown-checker
    wrapProgram $out/bin/spectre-meltdown-checker \
      --prefix PATH : ${makeBinPath [ binutils-unwrapped ]}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Spectre & Meltdown vulnerability/mitigation checker for Linux";
    homepage = https://github.com/speed47/spectre-meltdown-checker;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
