{ lib, buildGoModule, fetchFromSourcehut, fetchpatch, nixosTests }:

buildGoModule rec {
  pname = "alps";
  version = "2022-10-18";

  src = fetchFromSourcehut {
    owner = "~migadu";
    repo = "alps";
    rev = "f01fbcbc48db5e65d69a0ebd9d7cb0deb378cf13";
    hash = "sha256-RSug3YSiqYLGs05Bee4NoaoCyPvUZ7IqlKWI1hmxbiA=";
  };

  vendorHash = "sha256-QsGfINktk+rBj4b5h+NBVS6XV1SVz+9fDL1vtUqcKEU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.themesPath=${placeholder "out"}/share/alps/themes"
    "-X git.sr.ht/~migadu/alps.PluginDir=${placeholder "out"}/share/alps/plugins"
  ];

  patches = [
    (fetchpatch {
      name = "Issue-160-Alps-theme-has-a-enormous-move-to-list-sel";
      url = "https://lists.sr.ht/~migadu/alps-devel/patches/30096/mbox";
      hash = "sha256-Sz/SCkrrXZWrmJzjfPXi+UfCcbwsy6QiA7m34iiEFX0=";
    })
  ];

  postPatch = ''
    substituteInPlace plugin.go --replace "const PluginDir" "var PluginDir"
  '';

  postInstall = ''
    mkdir -p "$out/share/alps"
    cp -r themes plugins "$out/share/alps/"
  '';

  proxyVendor = true;

  passthru.tests = { inherit(nixosTests) alps; };

  meta = with lib; {
    description = "A simple and extensible webmail";
    homepage = "https://git.sr.ht/~migadu/alps";
    license = licenses.mit;
    maintainers = with maintainers; [ booklearner madonius hmenke ];
    mainProgram = "alps";
  };
}
