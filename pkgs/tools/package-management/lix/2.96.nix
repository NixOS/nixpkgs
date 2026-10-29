{
  fetchFromGitea,
  nix-update-script,
  rustPlatform,
}:
rec {
  version = "2.96.0";

  useMimalloc = true;
  useLicxxbridge = true;

  src = fetchFromGitea {
    domain = "git.lix.systems";
    owner = "lix-project";
    repo = "lix";
    rev = version;
    hash = "sha256-KKYenrZApSilj02krgybcdIu3S37bMrn00POKKpFc2Q=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "lix-${version}";
    inherit src;
    hash = "sha256-aLLl8Zp9txhAxlBj55lOo25NSz0z33pg1XDdEdCppy8=";
  };

  updateScript = nix-update-script {
    attrPath = "lixPackageSets.lix_2_96.lix";
    extraArgs = [
      "--override-filename=pkgs/tools/package-management/lix/2.96.nix"
      "--version-regex=^(2[.]96[.][0-9]+)$"
    ];
  };
}
