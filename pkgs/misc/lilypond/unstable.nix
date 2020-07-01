{ stdenv, fetchgit, lilypond, ghostscript, gyre-fonts }:

let

  version = "2.19.83";

in

lilypond.overrideAttrs (oldAttrs: {
  inherit version;

  src = fetchgit {
    url = "https://git.savannah.gnu.org/r/lilypond.git";
    rev = "release/${version}-1";
    sha256 = "1ycyx9x76d79jh7wlwyyhdjkyrwnhzqpw006xn2fk35s0jrm2iz0";
  };

  meta = oldAttrs.meta // {
    broken = stdenv.isDarwin;
  };
})
