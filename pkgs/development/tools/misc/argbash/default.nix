{ stdenv, fetchFromGitHub, autoconf, runtimeShell, python3Packages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "argbash";

  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "matejak";
    repo = "argbash";
    rev = "${version}";
    sha256 = "0zara7v3pnwiwkpb0x0g37pxhmim4425q4gba712f6djj115r1mr";
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

  meta = with stdenv.lib; {
    description = "Bash argument parsing code generator";
    homepage = "https://argbash.io/";
    license = licenses.free; # custom license.  See LICENSE in source repo.
    maintainers = with maintainers; [ rencire ];
  };
}
