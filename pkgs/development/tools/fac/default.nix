{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, git
}:

buildGoModule rec {
  pname = "fac";
  version = "unstable-2023-12-29";

  src = fetchFromGitHub {
    owner = "mkchoi212";
    repo = "fac";
    rev = "d232b05149564701ca3a21cd1a07be2540266cb2";
    hash = "sha256-puSHbrzxTUebK1qRdWh71jY/f7TKgONS45T7PcZcy00=";
  };

  vendorHash = "sha256-bmGRVTjleAFS5GGf2i/zN8k3SBtaEc3RbKSVZyF6eN4=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/fac \
      --prefix PATH : ${git}/bin

    # Install man page, not installed by default
    install -D assets/doc/fac.1 $out/share/man/man1/fac.1
  '';

  meta = {
    description = "CUI for fixing git conflicts";
    homepage = "https://github.com/mkchoi212/fac";
    changelog = "https://github.com/mkchoi212/fac/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
