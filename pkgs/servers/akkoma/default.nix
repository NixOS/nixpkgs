{
  lib,
  beamPackages,
  fetchFromGitea,
  cmake,
  file,
  nixosTests,
  nix-update-script,
}:

beamPackages.mixRelease rec {
  pname = "akkoma";
  version = "3.14.1";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "akkoma";
    tag = "v${version}";
    hash = "sha256-Ygb51jQatdyX/DzJk84X1AEliBGD938f83UnI5OqBPM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ file ];

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-nxxryKFBiFmjGQ8n83M7uOp37G9p/sKkUrf7ni8ceaM=";

    postInstall = ''
      substituteInPlace "$out/http_signatures/mix.exs" \
        --replace-fail ":logger" ":logger, :public_key"

      # Akkoma adds some things to the `mime` package's configuration, which
      # requires it to be recompiled. However, we can't just recompile things
      # like we would on other systems. Therefore, we need to add it to mime's
      # compile-time config too, and also in every package that depends on
      # mime, directly or indirectly. We take the lazy way out and just add it
      # to every dependency – it won't make a difference in packages that don't
      # depend on `mime`.
      for dep in "$out/"*; do
        mkdir -p "$dep/config"
        cat ${./mime.exs} >>"$dep/config/config.exs"
      done
    '';
  };

  postPatch = ''
    # Remove dependency on OS_Mon
    sed -E -i 's/(^|\s):os_mon,//' \
      mix.exs
  '';

  dontUseCmakeConfigure = true;

  postBuild = ''
    # Digest and compress static files
    rm -f priv/static/READ_THIS_BEFORE_TOUCHING_FILES_HERE
    mix do deps.loadpaths --no-deps-check, phx.digest --no-compile
  '';

  passthru = {
    tests = with nixosTests; {
      inherit akkoma akkoma-confined;
    };

    inherit mixFodDeps;

    # Used to make sure the service uses the same version of elixir as
    # the package
    elixirPackage = beamPackages.elixir;

    updateScript = nix-update-script { };
  };

  meta = {
    description = "ActivityPub microblogging server";
    homepage = "https://akkoma.social";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = lib.platforms.unix;
  };
}
