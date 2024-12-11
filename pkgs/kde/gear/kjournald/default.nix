{
  mkKdeDerivation,
  qtdeclarative,
  pkg-config,
  systemd,
}:
mkKdeDerivation {
  pname = "kjournald";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtdeclarative
    systemd
  ];
  meta.mainProgram = "kjournaldbrowser";
}
