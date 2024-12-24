{
  mkKdeDerivation,
  qtwebengine,
  akregator,
  kaddressbook,
  kmail,
  korganizer,
  zanshin,
}:
mkKdeDerivation {
  pname = "kontact";

  extraBuildInputs = [
    qtwebengine
    akregator
    kaddressbook
    kmail
    korganizer
    zanshin
  ];
  meta.mainProgram = "kontact";
}
