{ lib
, fetchFromGitHub
, fetchpatch
, applyPatches
, buildGoModule
, buildNpmPackage
, makeWrapper
, go-swag
, nixosTests
}:

buildGoModule rec {
  pname = "pufferpanel";
  version = "2.6.6";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "PufferPanel";
      repo = "PufferPanel";
      rev = "v${version}";
      hash = "sha256-0Vyi47Rkpe3oODHfsl/7tCerENpiEa3EWBHhfTO/uu4=";
    };
    patches = [
      # Bump go-sqlite3 version to avoid a GNU C compiler error.
      (fetchpatch {
        url = "https://github.com/PufferPanel/PufferPanel/commit/dd7fc80c33c7618c98311af09c78c25b77658aef.patch";
        hash = "sha256-ygMrhJoba8swoRBBii7BEiLihqOebLUtSH7os7W3s+k=";
      })

      # Fix errors in tests.
      (fetchpatch {
        url = "https://github.com/PufferPanel/PufferPanel/commit/ad6ab4b4368e1111292fadfb3d9f058fa399fa21.patch";
        hash = "sha256-BzGfcWhzRrCHKkAhWf0uvXiiiutWqthn/ed7bN2hR8U=";
      })

      # AutoFill for OTP codes in Safari.
      (fetchpatch {
        url = "https://github.com/PufferPanel/PufferPanel/commit/0c59ef0fe935ef8b5c69e0b91b32ecc2c1458f5c.patch";
        hash = "sha256-QpsEskw/xBhvesBGQQopiqXL0BRciF0j8KGcmKmJzeE=";
      })

      # Bump sha1cd package, otherwise i686-linux fails to build.
      ./bump-sha1cd.patch

      # Seems to be an anti-feature. Startup is the only place where user/group is
      # hardcoded and checked.
      #
      # There is no technical reason PufferPanel cannot run as a different user,
      # especially for simple commands like `pufferpanel version`.
      ./disable-group-checks.patch

      # Some tests do not have network requests stubbed :(
      ./skip-network-tests.patch
    ];
  };

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pufferpanel/pufferpanel/v2.Hash=none"
    "-X=github.com/pufferpanel/pufferpanel/v2.Version=${version}-nixpkgs"
  ];

  frontend = buildNpmPackage {
    pname = "pufferpanel-frontend";
    inherit version;

    src = "${src}/client";

    npmDepsHash = "sha256-geQHIbYYCOWsPQYAPiwMhtC+kbgQs7LMHqNYomTPrxA=";

    NODE_OPTIONS = "--openssl-legacy-provider";
    npmBuildFlags = [ "--" "--dest=${placeholder "out"}" ];
    dontNpmInstall = true;
  };

  nativeBuildInputs = [ makeWrapper go-swag ];

  vendorHash = "sha256-Esfk7SvqiWeiobXSI+4wYVEH9yVkB+rO7bxUQ5TzvG4=";
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
  };

  meta = with lib; {
    description = "A free, open source game management panel";
    homepage = "https://www.pufferpanel.com/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ckie tie ];
  };
}
