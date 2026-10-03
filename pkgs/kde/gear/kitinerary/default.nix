{
  mkKdeDerivation,
  qtsvg,
  qtdeclarative,
  shared-mime-info,
  poppler,
  libphonenumber,
  protobuf,
}:
mkKdeDerivation {
  pname = "kitinerary";

  extraNativeBuildInputs = [ shared-mime-info ];
  extraBuildInputs = [
    qtsvg
    qtdeclarative
    poppler
    libphonenumber
    protobuf
  ];

  preFixup = ''
    test -x "$out/libexec/kf6/kitinerary-extractor"
    mkdir -p "$out/bin"
    ln -s "$out/libexec/kf6/kitinerary-extractor" \
      "$out/bin/kitinerary-extractor"
  '';

  meta.mainProgram = "kitinerary-extractor";

}
