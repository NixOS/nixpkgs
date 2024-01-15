{ lib, rustPlatform, fetchFromGitHub, stdenv, testers, cbfmt }:

rustPlatform.buildRustPackage rec {
  pname = "cbfmt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lukas-reineke";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/ZvL1ZHXcmE1n+hHvJeSqmnI9nSHJ+zM9lLNx0VQfIE=";
  };

  cargoSha256 = "sha256-6oZCpjQ8t/QLFhEtF7td8KGI/kFE04pg7OELutsrJKo=";

  # Work around https://github.com/NixOS/nixpkgs/issues/166205.
  env = lib.optionalAttrs stdenv.cc.isClang { NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}"; };

  passthru.tests.version = testers.testVersion {
    package = cbfmt;
  };

  meta = with lib; {
    description = "A tool to format codeblocks inside markdown and org documents";
    homepage = "https://github.com/lukas-reineke/cbfmt";
    license = licenses.mit;
    maintainers = [ maintainers.stehessel ];
  };
}
