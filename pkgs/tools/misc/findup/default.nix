{ lib, stdenv, fetchFromGitHub, zig, testers, findup }:

stdenv.mkDerivation rec {
  pname = "findup";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "hiljusti";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-erlKIiYYlWnhoeD3FnKdxnHjfGmmJVXk44DUja5Unig=";
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
