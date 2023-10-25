{ fetchurl, lib, stdenv, zstd
, testers, buck2 # for passthru.tests
}:

let
  # NOTE (aseipp): buck2 uses a precompiled binary build for good reason — the
  # upstream codebase extensively uses unstable `rustc` nightly features, and as
  # a result can't be built upstream in any sane manner. it is only ever tested
  # and integrated against a single version of the compiler, which produces all
  # usable binaries. you shouldn't try to workaround this or get clever and
  # think you can patch it to work; just accept it for now. it is extremely
  # unlikely buck2 will build with a stable compiler anytime soon; see related
  # upstream issues:
  #
  #   - NixOS/nixpkgs#226677
  #   - NixOS/nixpkgs#232471
  #   - facebook/buck2#265
  #   - facebook/buck2#322
  #
  # worth noting: it *is* possible to build buck2 from source using
  # buildRustPackage, and it works fine, but only if you are using flakes and
  # can import `rust-overlay` from somewhere else to vendor your compiler. See
  # nixos/nixpkgs#226677 for more information about that.

  # map our platform name to the rust toolchain suffix
  suffix = {
    x86_64-darwin  = "x86_64-apple-darwin";
    aarch64-darwin = "aarch64-apple-darwin";
    x86_64-linux   = "x86_64-unknown-linux-musl";
    aarch64-linux  = "aarch64-unknown-linux-musl";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  buck2-version = "2023-07-18";
  src =
    let
      hashes = builtins.fromJSON (builtins.readFile ./hashes.json);
      sha256 = hashes."${stdenv.hostPlatform.system}";
      url = "https://github.com/facebook/buck2/releases/download/${buck2-version}/buck2-${suffix}.zst";
    in fetchurl { inherit url sha256; };
in
stdenv.mkDerivation {
  pname = "buck2";
  version = "unstable-${buck2-version}"; # TODO (aseipp): kill 'unstable' once a non-prerelease is made
  inherit src;

  nativeBuildInputs = [ zstd ];

  doCheck = true;
  dontConfigure = true;
  dontStrip = true;

  unpackPhase = "unzstd ${src} -o ./buck2";
  buildPhase = "chmod +x ./buck2";
  checkPhase = "./buck2 --version";
  installPhase = ''
    mkdir -p $out/bin
    install -D buck2 $out/bin/buck2
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = testers.testVersion {
      package = buck2;

      # NOTE (aseipp): the buck2 --version command doesn't actually print out
      # the given version tagged in the release, but a hash, but not the git
      # hash; the entire version logic is bizarrely specific to buck2, and needs
      # to be reworked the open source build to behave like expected. in the
      # mean time, it *does* always print out 'buck2 <hash>...' so we can just
      # match on "buck2"
      version = "buck2";
    };
  };

  meta = with lib; {
    description = "Fast, hermetic, multi-language build system";
    homepage = "https://buck2.build";
    changelog = "https://github.com/facebook/buck2/releases/tag/${buck2-version}";
    license = with licenses; [ asl20 /* or */ mit ];
    mainProgram = "buck2";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = [
      "x86_64-linux" "aarch64-linux"
      "x86_64-darwin" "aarch64-darwin"
    ];
  };
}
