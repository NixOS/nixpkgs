{ lib
, stdenv
, fetchFromGitHub
, testers
, zig_0_11
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dt";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "so-dang-cool";
    repo = "dt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C6sG8iqXs64x2AWCxKGFPyoXC1Fn4p2eSLWwJAQ8CSc=";
  };

  nativeBuildInputs = [ zig_0_11.hook ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://dt.plumbing";
    description = "Duct tape for your unix pipes";
    longDescription = ''
      dt is a utility and programming language. The utility is intended for
      ergonomic in-the-shell execution. The language is straightforward (in
      the most literal sense) with a minimal syntax that allows for
      high-level, higher-order programming.

      It's meant to supplement (not replace!) other tools like awk, sed,
      xargs, and shell built-ins. Something like the Perl one-liners popular
      yesteryear, but hopefully easier to read and reason through.

      In short, dt is intended to be generally useful, with zero pretense of
      elegance.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ booniepepper ];
    mainProgram = "dt";
  };
})
