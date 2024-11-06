{
  fetchzip,
  suffix,
  revision,
  system,
  throwSystem,
}:
fetchzip {
  url = "https://playwright.azureedge.net/builds/ffmpeg/${revision}/ffmpeg-${suffix}.zip";
  stripRoot = false;
  hash =
    {
      x86_64-linux = "sha256-FEm62UvMv0h6Sav93WmbPLw3CW1L1xg4nD26ca5ol38=";
      aarch64-linux = "sha256-jtQ+NS++VHRiKoIV++PIxEnyVnYtVwUyNlSILKSH4A4=";
    }
    .${system} or throwSystem;
}
