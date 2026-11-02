{
  fetchFromGitea,
  rustPlatform,
}:
rec {
  version = "2.97.0-pre-20261014_${builtins.substring 0 12 src.rev}";

  useMimalloc = true;
  useLicxxbridge = true;

  src = fetchFromGitea {
    domain = "git.lix.systems";
    owner = "lix-project";
    repo = "lix";
    rev = "3c5f629014e92037f9e446863441bcc5ba94eae3";
    hash = "sha256-q1afbP0uTTIFPUC4KMHbta+61saOMKQTsRbdvOs7rTw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "lix-${version}";
    inherit src;
    hash = "sha256-aLLl8Zp9txhAxlBj55lOo25NSz0z33pg1XDdEdCppy8=";
  };

  updateScript = ./update-git.sh;
}
