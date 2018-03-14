{ runCommand, withRatpoison, withDBus, withHome, withFonts, fmbtRun, zathura, pdfTest }:
runCommand "test-zathura" {
  buildInputs = [
    (withRatpoison {}) withDBus withHome (withFonts [])
    zathura
  ];
} ''
  zathura "${pdfTest}/text.pdf" &
  while ! ratpoison -c windows | grep -i text; do sleep 1; done
  ${fmbtRun ''
    screen.type("200=9999k9999h")
    assert(screen.waitOcrText("${pdfTest.text}",match=1,
      area=[0.0,0.0,1.0,1.0]))
  ''}

  mkdir -p "$out"/share/
  cp -r screenshots "$out/share"
  exit 0
''
