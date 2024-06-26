{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bc,
  xorgserver,
  xpra,
  xrandr,
}:

stdenv.mkDerivation {
  version = "unstable-2018-06-03";
  pname = "run-scaled";

  src = fetchFromGitHub {
    owner = "kaueraal";
    repo = "run_scaled";
    rev = "fa71b3c17e627a96ff707ad69f1def5361f2245c";
    sha256 = "1ma4ax7ydq4xvyzrc4zapihmf7v3d9zl9mbi8bgpps7nlgz544ys";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp run_scaled $out/bin
    wrapProgram $out/bin/run_scaled --prefix PATH ":" \
      ${
        lib.makeBinPath [
          bc
          xorgserver
          xpra
          xrandr
        ]
      }
  '';

  meta = with lib; {
    description = "Run an X application scaled via xpra";
    homepage = "https://github.com/kaueraal/run_scaled";
    maintainers = [ maintainers.snaar ];
    license = licenses.bsd3;
    platforms = platforms.unix;
    mainProgram = "run_scaled";
  };
}
