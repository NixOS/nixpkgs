{ lib
<<<<<<< HEAD
, fetchFromGitHub
, buildGoModule
, buildNpmPackage
, makeWrapper
, go-swag
, nixosTests
, testers
, pufferpanel
=======
, buildGoModule
, fetchFromGitHub
, makeWrapper
, fetchzip
, fetchpatch
, pathDeps ? [ ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "pufferpanel";
<<<<<<< HEAD
  version = "2.6.9";

  src = fetchFromGitHub {
    owner = "PufferPanel";
    repo = "PufferPanel";
    rev = "v${version}";
    hash = "sha256-+ZZUoqCiSbrkaeYrm9X8SuX0INsGFegQNwa3WjBvgHQ=";
  };

  patches = [
    # Bump sha1cd package, otherwise i686-linux fails to build.
    ./bump-sha1cd.patch
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  frontend = buildNpmPackage {
    pname = "pufferpanel-frontend";
    inherit version;

    src = "${src}/client";

    npmDepsHash = "sha256-oWFXtV/dxzHv3sfIi01l1lHE5tcJgpVq87XgS6Iy62g=";

    NODE_OPTIONS = "--openssl-legacy-provider";
    npmBuildFlags = [ "--" "--dest=${placeholder "out"}" ];
    dontNpmInstall = true;
  };

  nativeBuildInputs = [ makeWrapper go-swag ];

  vendorHash = "sha256-402ND99FpU+zNV1e5Th1+aZKok49cIEdpPPLLfNyL3E=";
  proxyVendor = true;

  # Generate code for Swagger documentation endpoints (see web/swagger/docs.go).
  # Note that GOROOT embedded in go-swag is empty by default since it is built
  # with -trimpath (see https://go.dev/cl/399214). It looks like go-swag skips
  # file paths that start with $GOROOT, thus all files when it is empty.
  preBuild = ''
    GOROOT=''${GOROOT-$(go env GOROOT)} swag init --output web/swagger --generalInfo web/loader.go
  '';

  installPhase = ''
    runHook preInstall

    # Set up directory structure similar to the official PufferPanel releases.
    mkdir -p $out/share/pufferpanel
    cp "$GOPATH"/bin/cmd $out/share/pufferpanel/pufferpanel
    cp -r $frontend $out/share/pufferpanel/www
    cp -r $src/assets/email $out/share/pufferpanel/email
    cp web/swagger/swagger.{json,yaml} $out/share/pufferpanel

    # Wrap the binary with the path to the external files, but allow setting
    # custom paths if needed.
    makeWrapper $out/share/pufferpanel/pufferpanel $out/bin/pufferpanel \
      --set-default GIN_MODE release \
      --set-default PUFFER_PANEL_EMAIL_TEMPLATES $out/share/pufferpanel/email/emails.json \
      --set-default PUFFER_PANEL_WEB_FILES $out/share/pufferpanel/www

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) pufferpanel;
    version = testers.testVersion {
      package = pufferpanel;
      command = "${pname} version";
    };
  };

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A free, open source game management panel";
    homepage = "https://www.pufferpanel.com/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ckie tie ];
<<<<<<< HEAD
    mainProgram = "pufferpanel";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
