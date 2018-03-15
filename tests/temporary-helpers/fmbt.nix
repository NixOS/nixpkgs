# an example wrapper around Intel free Model-Based Testing tool to provide
# GUI manipulation with OCR
#
# fmbtRun is a Nix function to generate shell code that runs the specified
#   test description in Python (after inistialising fmbt screen capture)
# copyScreenshots is just a small piece of shell code to copy the screenshots
#   taken by fmbt during the test
{ pkgs ? import ../../default.nix {} }:
pkgs.lib.makeExtensible (self: with self; {
  tesseract = pkgs.tesseract;
  fmbt = pkgs.fmbt.override {inherit tesseract; };

  fmbtHeader = ''
    import os
    import sys
    import fmbtx11
    import time

    screen = fmbtx11.Screen()
    screen.refreshScreenshot()
  '';
  fmbtRun = code: ''
    "${pkgs.lib.getBin fmbt}/bin/fmbt-python" \
      -c ${pkgs.lib.escapeShellArg fmbtHeader}${pkgs.lib.escapeShellArg code}
  '';
  copyScreenshots = ''
    mkdir -p "$out"/share/
    cp -r screenshots "$out/share"
  '';
})
