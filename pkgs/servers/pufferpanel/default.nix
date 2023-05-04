{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, fetchzip
, fetchpatch
, pathDeps ? [ ]
}:

buildGoModule rec {
  pname = "pufferpanel";
  version = "2.6.6";

  patches = [
    # Bump go-sqlite3 version to avoid a GNU C compiler error.
    # See https://github.com/PufferPanel/PufferPanel/pull/1240
    (fetchpatch {
      url = "https://github.com/PufferPanel/PufferPanel/pull/1240/commits/3065dca2d9b05a56789971ccf0f43a7079a390b8.patch";
      hash = "sha256-ygMrhJoba8swoRBBii7BEiLihqOebLUtSH7os7W3s+k=";
    })

    # Fix errors in tests.
    # See https://github.com/PufferPanel/PufferPanel/pull/1241
    (fetchpatch {
      url = "https://github.com/PufferPanel/PufferPanel/pull/1241/commits/ffd21bce4bff3040c8e3e783e5b4779222e7a3a5.patch";
      hash = "sha256-BzGfcWhzRrCHKkAhWf0uvXiiiutWqthn/ed7bN2hR8U=";
    })

    # Seems to be an anti-feature. Startup is the only place where user/group is
    # hardcoded and checked.
    #
    # There is no technical reason PufferPanel cannot run as a different user,
    # especially for simple commands like `pufferpanel version`.
    ./disable-group-checks.patch

    # Some tests do not have network requests stubbed :(
    ./skip-network-tests.patch
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pufferpanel/pufferpanel/v2.Hash=none"
    "-X=github.com/pufferpanel/pufferpanel/v2.Version=${version}-nixpkgs"
  ];

  src = fetchFromGitHub {
    owner = "pufferpanel";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0Vyi47Rkpe3oODHfsl/7tCerENpiEa3EWBHhfTO/uu4=";
  };

  # PufferPanel is split into two parts: the backend daemon and the
  # frontend.
  # Getting the frontend to build in the Nix environment fails even
  # with all the proper node_modules populated. To work around this,
  # we just download the built frontend and package that.
  frontend = fetchzip {
    url = "https://github.com/PufferPanel/PufferPanel/releases/download/v${version}/pufferpanel_${version}_linux_arm64.zip";
    hash = "sha256-z7HWhiEBma37OMGEkTGaEbnF++Nat8wAZE2UeOoaO/U=";
    stripRoot = false;
    postFetch = ''
      mv $out $TMPDIR/subdir
      mv $TMPDIR/subdir/www $out
    '';
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-fB8MxSl9E2W+BdO6i+drbCe9Z3bPHPi0MvpJEomU9co=";
  proxyVendor = true;

  postFixup = ''
    mkdir -p $out/share/pufferpanel
    cp -r ${src}/assets/email $out/share/pufferpanel/templates
    cp -r ${frontend} $out/share/pufferpanel/www

    # Rename cmd to pufferpanel and remove other binaries.
    mv $out/bin $TMPDIR/bin
    mkdir $out/bin
    mv $TMPDIR/bin/cmd $out/bin/pufferpanel

    # Wrap the binary with the path to the external files, but allow setting
    # custom paths if needed.
    wrapProgram $out/bin/pufferpanel \
      --set-default GIN_MODE release \
      --set-default PUFFER_PANEL_EMAIL_TEMPLATES $out/share/pufferpanel/templates/emails.json \
      --set-default PUFFER_PANEL_WEB_FILES $out/share/pufferpanel/www \
      --prefix PATH : ${lib.escapeShellArg (lib.makeBinPath pathDeps)}
  '';

  meta = with lib; {
    description = "A free, open source game management panel";
    homepage = "https://www.pufferpanel.com/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ckie tie ];
  };
}
