{ stdenv, fetchFromGitLab, autoreconfHook }:
let
  version = "v2.2";
in
stdenv.mkDerivation{
  name = "iucode_tool-${version}";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitLab {
    owner = "iucode-tool";
    repo = "iucode-tool";
    rev = version;
    sha256 = "0ndh33rj3l9gp7xkx7m167p2svp4m3fzmzblc6xpz4ldmwsjnrnc";
  };

  meta = with stdenv.lib; {
    description = ''
      iucode_tool is a program to manipulate microcode update
      collections for Intel:registered: i686 and X86-64 system processors, and
      prepare them for use by the Linux kernel. Please refer to the project wiki
      for documentation and more details.
    '';
    homepage = https://gitlab.com/iucode-tool/iucode-tool;
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
