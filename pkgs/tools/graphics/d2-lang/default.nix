{ fetchFromGitHub
, buildGoModule
, git
, lib
}:
buildGoModule rec {
  pname = "d2-lang";
  version = "v0.0.13";

  vendorHash = "sha256-/BEl4UqOL4Ux7I2eubNH2YGGl4DxntpI5WN9ggvYu80=";
  nativeBuildInputs = [ git ];
  postInstall = "rm $out/bin/{report,d2plugin-dagre}";

  patches = [ ./omit-host-fix.patch ];
  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = "d2";
    rev = version;
    hash = "sha256-2abGQmgwqxWFk7NScdgfEjRYZF2rw8kxTKRwcl2LRg0=";
  };

  meta = {
    license = lib.licenses.mpl20;
    homepage = "https://d2lang.com";
    description = "Declarative diagramming tool";
    longDescription = ''
      D2 is a domain-specific language (DSL) that stands for Declarative Diagramming.
      Declarative, as in, you describe what you want diagrammed, it generates the image.
      '';
  };
}
