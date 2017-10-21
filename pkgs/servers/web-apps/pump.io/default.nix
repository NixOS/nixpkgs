{ pkgs, system, stdenv, fetchurl, makeWrapper, nodejs, graphicsmagick }:

with stdenv.lib;

let
  # To regenerate composition.nix, run generate.sh.
  nodePackages = import ./composition.nix {
    inherit pkgs system nodejs;
  };
in
nodePackages.package.override (oldAttrs: {
  buildInputs = oldAttrs.buildInputs ++ [ makeWrapper ];

  postInstall = ''
    for prog in pump pump-authorize pump-follow pump-post-note pump-register-app pump-register-user pump-stop-following; do
      wrapProgram "$out/bin/$prog" \
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
})
