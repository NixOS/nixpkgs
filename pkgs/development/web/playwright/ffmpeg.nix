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
      x86_64-linux = "";
      aarch64-linux = "";
      x86_64-darwin = "";
      aarch64-darwin = "";
    }
    .${system} or throwSystem;
}
