{ lib, stdenv, fetchFromGitHub, autoconf, runtimeShell, python3Packages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "argbash";

  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "matejak";
    repo = "argbash";
    rev = version;
    sha256 = "1xdhpbnc0xjv6ydcm122hhdjcl77jhiqnccjfqjp3cd1lfmzvg8v";
  };

  sourceRoot = "source/resources";

  postPatch = ''
    chmod -R +w ..
    patchShebangs ..
    substituteInPlace Makefile \
      --replace '/bin/bash' "${runtimeShell}"
  '';

  nativeBuildInputs = [ autoconf python3Packages.docutils makeWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/argbash \
      --prefix PATH : '${autoconf}/bin'
  '';

  meta = with lib; {
    description = "Bash argument parsing code generator";
    homepage = "https://argbash.io/";
    license = licenses.free; # custom license.  See LICENSE in source repo.
    maintainers = with maintainers; [ rencire ];
  };
}
