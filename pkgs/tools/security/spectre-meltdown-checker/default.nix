{ stdenv, fetchFromGitHub, makeWrapper, coreutils, binutils-unwrapped }:

stdenv.mkDerivation rec {
  pname = "spectre-meltdown-checker";
  version = "0.43";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
    rev = "v${version}";
    sha256 = "1ys5m1yvm26qjlsjpqqd33lwpb880p0ay289hmifxjjawkqddjgg";
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
    homepage = "https://github.com/speed47/spectre-meltdown-checker";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
