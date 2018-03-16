{ runCommand, libreoffice, meta ? {}, lib }:
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
with import ./temporary-helpers/fmbt.nix {};
runCommand "test-libreoffice" {
  buildInputs = [
          (import ./temporary-helpers/with-dbus.nix {})
          (import ./temporary-helpers/with-ratpoison.nix {})
          (import ./temporary-helpers/with-home.nix {})
          libreoffice ];
  meta = lib.recursiveUpdate {
    description = "Check that ${libreoffice.name} can start and create a spreadsheet via menu";
  } meta;
} ''
  soffice &
  waitWindow libreoffice "%c"

  ${fmbtRun fmbtScripts.startSpreadsheet}
  ratpoison -c windows | grep "Calc"

  ${copyScreenshots}
''
