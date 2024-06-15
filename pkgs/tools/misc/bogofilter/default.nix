{ lib
, stdenv
, fetchurl
, flex
, db
, makeWrapper
, pax
}:

stdenv.mkDerivation rec {
  pname = "bogofilter";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/bogofilter/bogofilter-${version}.tar.xz";
    hash = "sha256-MkihNzv/VSxQCDStvqS2yu4EIkUWrlgfslpMam3uieo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ flex db ];

  doCheck = false; # needs "y" tool

  postInstall = ''
    wrapProgram "$out/bin/bf_tar" --prefix PATH : "${lib.makeBinPath [ pax ]}"
  '';

  meta = {
    homepage = "http://bogofilter.sourceforge.net/";
    longDescription = ''
      Bogofilter is a mail filter that classifies mail as spam or ham
      (non-spam) by a statistical analysis of the message's header and
      content (body).  The program is able to learn from the user's
      classifications and corrections.  It is based on a Bayesian
      filter.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
