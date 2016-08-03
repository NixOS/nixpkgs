{ stdenv, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {

  name = "rolespec-${meta.version}";

  src = fetchFromGitHub {
    owner = "nickjj";
    repo = "rolespec";
    rev = "64a2092773b77f7a888522ceddd815e97b129321";
    sha256 = "1867acxy18a3cgi84iwsp37sxglaljn1dq50amahp5zkmd8x8vnz";
    inherit name;
  };

  buildInputs = [ makeWrapper ];

  # The default build phase (`make`) runs the test code. It's difficult to do
  # the test in the build environment because it depends on the system package
  # managers (apt/yum/pacman). We simply skip this phase since RoleSpec is
  # shell based.
  dontBuild = true;

  # Wrap the program because `ROLESPEC_LIB` defaults to
  # `/usr/local/lib/rolespec`.
  installPhase = ''
    make install PREFIX=$out
    wrapProgram $out/bin/rolespec --set ROLESPEC_LIB $out/lib/rolespec
  '';

  # Since RoleSpec installs the shell script files in `lib` directory, the
  # fixup phase shows some warnings. Disable these actions.
  dontPatchELF = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/nickjj/rolespec";
    description = "A test library for testing Ansible roles";
    longDescription = ''
      A shell based test library for Ansible that works both locally and over
      Travis-CI.
    '';
    downloadPage = "https://github.com/nickjj/rolespec";
    license = licenses.gpl3;
    version = "20160105";
    maintainers = [ maintainers.dochang ];
    platforms = platforms.unix;
  };

}
