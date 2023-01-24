{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, pkgs
, stdenv
, fetchzip
, jdk
, nodejs
, pathDeps ? [ ]
}:

buildGoModule rec {
  pname = "pufferpanel";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "pufferpanel";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ifig8ckjlg47wj0lfk4q941dan7llb1i5l76akcpjq726b2j8lh";
  };

  # PufferPanel is split into two parts: the backend daemon and the
  # frontend.
  # Getting the frontend to build in the Nix environment fails even
  # with all the proper node_modules populated. To work around this,
  # we just download the built frontend and package that.
  frontend = fetchzip {
    url = "https://github.com/PufferPanel/PufferPanel/releases/download/v${version}/pufferpanel_${version}_linux_arm64.zip";
    sha256 = "0phbf4asr0dns7if84crx05kfgr44yaxrbsbihdywbhh2mb16052";
    stripRoot = false;
  } + "/www";

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = "061l1sy0z3kd7rc2blqh333gy66nbadfxy9hyxgq07dszds4byys";

  postFixup = ''
    mkdir -p $out/share/pufferpanel
    cp -r ${src}/assets/email $out/share/pufferpanel/templates
    cp -r ${frontend} $out/share/pufferpanel/www

    # Wrap the binary with the path to the external files.
    mv $out/bin/cmd $out/bin/pufferpanel
    wrapProgram "$out/bin/pufferpanel" \
      --set PUFFER_PANEL_EMAIL_TEMPLATES $out/share/pufferpanel/templates/emails.json \
      --set GIN_MODE release \
      --set PUFFER_PANEL_WEB_FILES $out/share/pufferpanel/www \
      --prefix PATH : ${lib.escapeShellArg (lib.makeBinPath pathDeps)}
  '';

  meta = with lib; {
    description = "A free, open source game management panel";
    homepage = "https://www.pufferpanel.com/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ckie ];
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/pufferpanel.x86_64-darwin
  };
}
