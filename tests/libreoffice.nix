{ runCommand, withDBus, withRatpoison, withHome, fmbtRun, libreoffice }:
let
  fmbtScripts = {
    startSpreadsheet = ''
      assert(screen.verifyOcrText("File",match=1,area=[0.0, 0.0, 0.2, 0.2]))
      screen.tapOcrText("File", area=[0.0, 0.0, 0.2, 0.2])
      assert(screen.waitOcrText("New",area=[0.0, 0.0, 0.2, 0.2]))
      screen.tapOcrText("New", area=[0.0, 0.0, 0.2, 0.2])
      assert(screen.waitOcrText("Spreadsheet",area=[0.0, 0.0, 0.7, 0.2]))
      screen.tapOcrText("Spreadsheet", area=[0.0, 0.0, 0.7, 0.2])
      time.sleep(1)
      screen.refreshScreenshot()
    '';
  };
in
runCommand "test-libreoffice" {
  buildInputs = [ withDBus (withRatpoison {}) withHome libreoffice ];
} ''
  soffice &
  while ! ratpoison -c "windows %c" | grep -i libreoffice; do sleep 1; done

  ${fmbtRun fmbtScripts.startSpreadsheet}
  ratpoison -c windows | grep "Calc"

  mkdir -p "$out"/share/
  cp -r screenshots "$out/share"
  exit 0
''
