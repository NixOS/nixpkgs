{
  mkKdeDerivation,
  intltool,
  qtdeclarative,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "kaccounts-providers";

  extraNativeBuildInputs = [intltool];
  extraBuildInputs = [qtdeclarative qtwebengine];
}
