{ runCommand, zathura, pdfTest }:
with import ./temporary-helpers/fmbt.nix {};
runCommand "test-zathura" {
  buildInputs = [
    (import ./temporary-helpers/with-dbus.nix {})
    (import ./temporary-helpers/with-ratpoison.nix {})
    (import ./temporary-helpers/with-home.nix {})
    (import ./temporary-helpers/with-fonts.nix {})
    zathura
  ];
} ''
  zathura "${pdfTest}/text.pdf" &
  waitWindow text
  
  ${fmbtRun ''
    screen.type("200=9999k9999h")
    assert(screen.waitOcrText("${pdfTest.text}",match=1,
      area=[0.0,0.0,1.0,1.0]))
  ''}

  ${copyScreenshots}
''
