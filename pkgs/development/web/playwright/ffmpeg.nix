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
      x86_64-linux = "sha256-AWTiui+ccKHxsIaQSgc5gWCJT5gYwIWzAEqSuKgVqZU=";
      aarch64-linux = "sha256-1mOKO2lcnlwLsC6ob//xKnKrCOp94pw8X14uBxCdj0Q=";
      x86_64-darwin = "sha256-zJ8BMzdneV6LlEt4I034l5u86dwW4UmO/UazWikpKV4=";
      aarch64-darwin = "sha256-ky10UQj+XPVGpaWAPvKd51C5brml0y9xQ6iKcrxAMRc=";
    }
    .${system} or throwSystem;
}
