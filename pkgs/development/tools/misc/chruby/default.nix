{ stdenv, lib, fetchFromGitHub, runCommand, rubies ? null }:

let
  rubiesEnv = runCommand "chruby-env" { preferLocalBuild = true; } ''
    mkdir $out
    ${lib.concatStrings
        (lib.mapAttrsToList (name: path: "ln -s ${path} $out/${name}\n") rubies)}
  '';

in stdenv.mkDerivation rec {
  name = "chruby";

  src = fetchFromGitHub {
    owner = "postmodern";
    repo = "chruby";
    rev = "d5ae98410311aec1358d4cfcc1e3ec02de593c3b";
    sha256 = "1iq9milnnj3189yw02hkly2pnnh4g0vn2fxq6dfx90kldjwpwxq5";
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
