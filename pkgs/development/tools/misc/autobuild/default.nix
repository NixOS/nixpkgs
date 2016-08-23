{ fetchurl, stdenv, makeWrapper, perl, openssh, rsync }:

stdenv.mkDerivation rec {
  name = "autobuild-5.3";

  src = fetchurl {
    url = "http://savannah.spinellicreations.com/autobuild/${name}.tar.gz";
    sha256 = "0gv7g61ja9q9zg1m30k4snqwwy1kq7b4df6sb7d2qra7kbdq8af1";
  };

  buildInputs = [ makeWrapper perl openssh rsync ];

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/ab{put,build}-sourceforge \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ openssh rsync ]}"
  '';

  meta = {
    description = "Continuous integration tool";

    longDescription = ''
      Autobuild is a package that process output from building
      software, primarily focused on packages using Autoconf and
      Automake, and then generate a HTML summary file, containing
      links to each build log.

      Autobuild can also help you automate building your project on
      many systems concurrently.  Users with accounts on the
      SourceForge compile farms will be able to invoke a parallel
      build of their Autoconf/Automake based software, and produce a
      summary of the build status, after reading the manual.
    '';

    homepage = http://josefsson.org/autobuild/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
