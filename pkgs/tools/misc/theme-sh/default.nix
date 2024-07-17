{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gawk,
}:

stdenv.mkDerivation rec {
  pname = "theme-sh";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "lemnos";
    repo = "theme.sh";
    rev = "v${version}";
    sha256 = "sha256-zDw8WGBzO4/HRCgN7yoUxT49ibTz+QkRa5WpBQbl1nI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 bin/theme.sh $out/bin
    wrapProgram $out/bin/theme.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    description = "A script which lets you set your $terminal theme";
    homepage = "https://github.com/lemnos/theme.sh";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "theme.sh";
  };
}
