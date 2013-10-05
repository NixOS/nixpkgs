{ fetchurl, stdenv, makeWrapper, perl, openssh, rsync }:

stdenv.mkDerivation rec {
  name = "autobuild-3.5";

  src = fetchurl {
    url = "http://savannah.spinellicreations.com/autobuild/${name}.tar.gz";
    sha256 = "0ik13913x1yj8lsaf65chpiw13brl3q6kx7s1fa41a7s2krl1xvi";
  };

  buildInputs = [ makeWrapper perl openssh rsync ];

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/ab{put,build}-sourceforge \
      --prefix PATH ":" "${openssh}/bin:${rsync}/bin"
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
    license = "GPLv2+";
  };
}
