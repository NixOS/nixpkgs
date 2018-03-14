{ runCommand, withRatpoison, withDBus, withHome, withFonts, fmbtRun, evince, pdfTest }:
runCommand "test-evince" {
  buildInputs = [
    (withRatpoison {}) withDBus withHome (withFonts [])
    evince
  ];
} ''
  evince "${pdfTest}/text.pdf" &
  while ! ratpoison -c windows | grep -i text; do sleep 1; done
  ${fmbtRun ''
    assert(screen.waitOcrText("${pdfTest.text}",match=1,
      area=[0.0,0.0,1.0,1.0]))
  ''}

  mkdir -p "$out"/share/
  cp -r screenshots "$out/share"
  exit 0
''
