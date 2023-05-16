<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, testers
, zig_0_10
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findup";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "booniepepper";
    repo = "findup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Tpyiy5oJQ04lqVEOFshFC0+90VoNILQ+N6Dd7lbuH/Q=";
  };

  nativeBuildInputs = [ zig_0_10.hook ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.findup; };

  meta = {
    homepage = "https://github.com/booniepepper/findup";
    description = "Search parent directories for sentinel files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booniepepper ];
  };
})
=======
{ lib, stdenv, fetchFromGitHub, zig, testers, findup }:

stdenv.mkDerivation rec {
  pname = "findup";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "hiljusti";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fafMBC/ibCHgC3JwCNEh74Qw/yZ+KQF//z1e+OpeGus=";
  };

  nativeBuildInputs = [ zig ];

  # Builds and installs (at the same time) with Zig.
  dontConfigure = true;
  dontBuild = true;

  # Give Zig a directory for intermediate work.
  preInstall = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = findup; };

  meta = with lib; {
    homepage = "https://github.com/hiljusti/findup";
    description = "Search parent directories for sentinel files";
    license = licenses.mit;
    maintainers = with maintainers; [ hiljusti ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
