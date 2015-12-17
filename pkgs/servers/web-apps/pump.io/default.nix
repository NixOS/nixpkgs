{ stdenv, fetchFromGitHub, makeWrapper, callPackage, nodejs, python, utillinux, graphicsmagick }:

with stdenv.lib;

let
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    inherit stdenv nodejs fetchurl fetchgit;
    neededNatives = [ python ] ++ optional stdenv.isLinux utillinux;
    self = nodePackages;
    generated = ./node-packages.nix;
  };

in nodePackages.buildNodePackage rec {
  version = "git-2015-11-09";
  name = "pump.io-${version}";

  src = fetchFromGitHub {
    owner = "e14n";
    repo = "pump.io";
    rev = "2f8d6b3518607ed02b594aee0db6ccacbe631b2d";
    sha256 = "1xym3jzpxlni1n2i0ixwrnpkx5fbnd1p6sm1hf9n3w5m2lx6gdw5";
  };

  deps = (filter (v: nixType v == "derivation") (attrValues nodePackages));

  buildInputs = [ makeWrapper ];

  postInstall = ''
    for prog in pump pump-authorize pump-follow pump-post-note pump-register-app pump-register-user pump-stop-following; do
      wrapProgram "$out/bin/$prog" \
        --set NODE_PATH "$out/lib/node_modules/pump.io/node_modules/" \
        --prefix PATH : ${graphicsmagick}/bin:$out/bin
    done
  '';

  passthru.names = ["pump.io"];

  meta = {
    description = "Social server with an ActivityStreams API";
    homepage = http://pump.io/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.rvl ];
    longDescription = ''
      This is pump.io. It's a stream server that does most of what
      people really want from a social network.

      What's it for?

      I post something and my followers see it. That's the rough idea
      behind the pump.

      There's an API defined in the API.md file. It uses
      activitystrea.ms JSON as the main data and command format.

      You can post almost anything that can be represented with
      activity streams -- short or long text, bookmarks, images,
      video, audio, events, geo checkins. You can follow friends,
      create lists of people, and so on.

      The software is useful for at least these scenarios:

      * Mobile-first social networking
      * Activity stream functionality for an existing app
      * Experimenting with social software
    '';
  };
}
