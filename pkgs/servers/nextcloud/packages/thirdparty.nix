{ pkgs }: {
  apps = {
    hmr_enabler = pkgs.php.buildComposerProject (finalAttrs: {
      pname = "hmr_enabler";
      version = "0+unstable-2024-07-15";
      src = pkgs.fetchFromGitHub {
        owner = "nextcloud";
        repo = "hmr_enabler";
        rev = "6e6cad80b8ebe296b49c1057c1faf82df8815026";
        hash = "sha256-Hno/dfQ4N9OWtir+Lixg7UAjahmKLc6CoTxiAH6Mnjk=";
      };
      composerNoDev = false;
      vendorHash = "sha256-OIC3b9Wg72s01U7s3rhMWXf/xLUwjkuP7TKeNO69lZI=";
      postInstall = ''
        cp -r $out/share/php/hmr_enabler/* $out/
        rm -r $out/share
      '';
    });
  };
}
