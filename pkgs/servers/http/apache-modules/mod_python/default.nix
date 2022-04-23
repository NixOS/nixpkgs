{ lib, stdenv, fetchFromGitHub, apacheHttpd, python3, libintl }:

stdenv.mkDerivation rec {
  pname = "mod_python";
  version = "unstable-2022-04-18";

  src = fetchFromGitHub {
    owner = "grisha";
    repo = "mod_python";
    rev = "8fded887b664a5c57b6b015fbd82ef7ca9c31021";
    hash = "sha256-IFSWZoVqTwNaW9qh78uojy5GFG4mn4vfgG5OKN+1bjw=";
  };

  postPatch = ''
    substituteInPlace dist/version.sh \
        --replace '$GIT' ""
  '';

  installFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  postInstall = ''
    mv $out/nix/store/*/* $out/
    rm -rf $out/nix
  '';

  passthru = { inherit apacheHttpd; };

  buildInputs = [ apacheHttpd python3 ]
    ++ lib.optional stdenv.isDarwin libintl;

  meta = {
    homepage = "http://modpython.org/";
    description = "An Apache module that embeds the Python interpreter within the server";
    platforms = lib.platforms.unix;
  };
}
