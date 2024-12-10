{
  lib,
  fetchFromGitHub,
  installShellFiles,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zi";
  version = "unstable-2022-04-09";
  src = fetchFromGitHub {
    owner = "z-shell";
    repo = pname;
    rev = "4ca4d3276ca816c3d37a31e47d754f9a732c40b9";
    sha256 = "sha256-KcDFT0is5Ef/zRo6zVfxYfBMOb5oVaVFT4EsUrfiMko=";
  };

  dontBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out
    cp -r lib zi.zsh $out
    installManPage docs/man/zi.1
    installShellCompletion --zsh lib/_zi
  '';

  meta = with lib; {
    homepage = "https://github.com/z-shell/zi";
    description = "A Swiss Army Knife for Zsh - Unix Shell";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
  };
}
