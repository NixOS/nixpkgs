{ stdenv, fetchFromGitLab
, pulseaudioFull
, libopenaptx }:

(pulseaudioFull.override {
  fromGit = true;
}).overrideAttrs (oldAttrs: {
  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pali";
    repo = "pulseaudio";
    rev = "8dd863ac78c0c2d2eef48841dfb00b58b5f8aea7"; # hsphfpd, 2020-10-25
    sha256 = "01r2wzwr23f8243165a4lqx2p33fw4vqp5fdpq3jf6jc7wkqnrpb";
  };

  buildInputs = (oldAttrs.buildInputs or []) ++ [ libopenaptx ];
})
