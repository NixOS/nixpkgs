{ python3, fetchFromGitHub, fetchpatch, lib }:

python3.pkgs.buildPythonApplication rec {
  pname = "dnd-tools";
  version = "unstable-2021-02-18";

  src = fetchFromGitHub {
    owner = "savagezen";
    repo = pname;
    rev = "baefb9e4b4b8279be89ec63d256dde9704dee078";
    sha256 = "1rils3gzbfmwvgy51ah77qihwwbvx50q82lkc1kwcb55b3yinnmj";
  };

  # gives warning every time unless patched, see https://github.com/savagezen/dnd-tools/pull/20
  patches = [
    (fetchpatch {
      url = "https://github.com/savagezen/dnd-tools/commit/0443f3a232056ad67cfb09eb3eadcb6344659198.patch";
      sha256 = "00k8rsz2aj4sfag6l313kxbphcb5bjxb6z3aw66h26cpgm4kysp0";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/savagezen/dnd-tools";
    description = "A set of interactive command line tools for Dungeons and Dragons 5th Edition";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.urlordjames ];
  };
}
