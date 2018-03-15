{ runCommand, evince, pdfTest }:
with import ./temporary-helpers/fmbt.nix {};
runCommand "test-evince" {
  buildInputs = [
    (import ./temporary-helpers/with-dbus.nix {})
    (import ./temporary-helpers/with-ratpoison.nix {})
    (import ./temporary-helpers/with-home.nix {})
    (import ./temporary-helpers/with-fonts.nix {})
    evince
  ];
} ''
  evince "${pdfTest}/text.pdf" &
  waitWindow text

  ${fmbtRun ''
    assert(screen.waitOcrText("${pdfTest.text}",match=1,
      area=[0.0,0.0,1.0,1.0]))
  ''}

  ${copyScreenshots}
''
