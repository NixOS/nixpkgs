{ stdenv, buildPackages, bundlerUpdateScript, fetchFromGitHub, nixosTests
, oniguruma
# installCheck inputs
, bundlerApp ? null
# features
# (enabling Valgrind checks for testing severly increases build time)
, enableValgrindChecks ? false
, valgrind ? null, which ? null
}:

assert enableValgrindChecks -> valgrind != null;
assert enableValgrindChecks -> which != null;

let
  inherit (stdenv) lib;

  # from ./docs/Gemfile{,.lock}
  docsRubyApp = rec {
    pname = "rake";
    gemdir = ./.;
    exes = [ "rake" ];
  };
  buildDocsRuby = buildPackages.bundlerApp docsRubyApp;
  docsRuby = bundlerApp docsRubyApp;
in

stdenv.mkDerivation rec {
  pname = "jq";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "stedolan";
    repo = "jq";
    rev = "jq-${version}";
    sha256 = "1fnf2m46ya7r7afkcb8ba2j0sc4a85m749sh9jz64g4hx6z3r088";
  };

  outputs = [ "bin" "doc" "man" "dev" "lib" "out" ];

  nativeBuildInputs = [
    buildPackages.autoreconfHook
  ];
  buildInputs = [
    oniguruma
  ];
  installCheckInputs = [
    docsRuby
  ] ++ lib.optionals enableValgrindChecks [
    valgrind
    which
  ];

  patches = [
    ./nix-docs-ruby.patch
    ./nix-version.patch
  ];

  postPatch = ''
    for file in configure.ac scripts/version; do
      substituteInPlace "$file" \
        --subst-var version
    done

    substituteInPlace Makefile.am \
      --subst-var-by docs_rake ${lib.escapeShellArg buildDocsRuby}/bin/rake
  '';

  configureFlags = [
    (lib.enableFeature enableValgrindChecks "valgrind")
    "--bindir=\${bin}/bin"
    "--sbindir=\${bin}/bin"
    "--datadir=\${doc}/share"
    "--mandir=\${man}/share/man"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # jq is linked to libjq:
    "LDFLAGS=-Wl,-rpath,\\\${libdir}"
  ];

  doInstallCheck = true;
  installCheckTarget = "check";

  postInstallCheck = ''
    ''${bin}/bin/jq --help >/dev/null
  '';

  passthru.tests = { inherit (nixosTests) jq; };
  passthru.updateScript = bundlerUpdateScript "jq";

  meta = {
    description = ''A lightweight and flexible command-line JSON processor'';
    downloadPage = "https://stedolan.github.io/jq/download/";
    homepage = "https://stedolan.github.io/jq/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin globin bb010g ];
    platforms = with lib.platforms; linux ++ darwin;
    updateWalker = true;
  };
}
