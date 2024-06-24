{
  mkKdeDerivation,
  qtwebengine,
  akregator,
  kaddressbook,
  kmail,
  knotes,
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
    knotes
    korganizer
    zanshin
  ];
  meta.mainProgram = "kontact";
}
