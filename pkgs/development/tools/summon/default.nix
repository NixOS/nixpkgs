{ buildGoModule, fetchFromGitHub, lib, patchResolver ? true }:

buildGoModule rec {
  pname = "summon";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${version}";
    sha256 = "1z4xnrncwvp3rfm97zvc0ivvw2fh1hrjhj3rplvidzxjfyasbvwv";
  };

  vendorSha256 = "1597vrs4b7k6gkmkvf7xnd38rvjixmlcz0j7npmik9nbkm57l74m";

  subPackages = [ "cmd" ];

  # Patches provider resolver to support resolving unqualified names
  # from $PATH, e.g. `summon -p gopass` instead of `summon -p $(which gopass)`
  patches = lib.optionals patchResolver [ ./resolve-paths.patch ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/summon
  '';

  meta = with lib; {
    description =
      "CLI that provides on-demand secrets access for common DevOps tools";
    homepage = "https://cyberark.github.io/summon";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ quentini ];
  };
}
