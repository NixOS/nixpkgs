{ stdenv, lib, fetchFromGitHub, runCommand, rubies ? null }:

let
  rubiesEnv = runCommand "chruby-env" { preferLocalBuild = true; } ''
    mkdir $out
    ${lib.concatStrings
        (lib.mapAttrsToList (name: path: "ln -s ${path} $out/${name}\n") rubies)}
  '';

in stdenv.mkDerivation rec {
  name = "chruby-${version}";

  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "postmodern";
    repo = "chruby";
    rev = "v${version}";
    sha256 = "1894g6fymr8kra9vwhbmnrcr58l022mcd7g9ans4zd3izla2j3gx";
  };

  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];

  patches = lib.optionalString (rubies != null) [
    ./env.patch
  ];

  postPatch = lib.optionalString (rubies != null) ''
    substituteInPlace share/chruby/chruby.sh --replace "@rubiesEnv@" ${rubiesEnv}
  '';

  installPhase = ''
    mkdir $out
    cp -r bin $out
    cp -r share $out
  '';

  meta = with lib; {
    description = "Changes the current Ruby";
    homepage = https://github.com/postmodern/chruby;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
