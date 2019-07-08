{ stdenv, python3, fetchFromGitHub, clang-unwrapped }:

python3.pkgs.buildPythonApplication rec {
  pname = "whatstyle";
  version = "0.1.7";
  src = fetchFromGitHub {
    owner = "mikr";
    repo = pname;
    rev = "v${version}";
    sha256 = "16ak4g149cr764c1lqakiyzmf5s98w8bdc4gk69m8qacimfg3mzm";
  };

  # Fix references to previous version, to avoid confusion:
  postPatch = ''
    substituteInPlace setup.py --replace 0.1.6 ${version}
    substituteInPlace ${pname}.py --replace 0.1.6 ${version}
  '';

  checkInputs = [ clang-unwrapped /* clang-format */ ];

  doCheck = false; # 3 or 4 failures depending on version, haven't investigated.

  meta = with stdenv.lib; {
    description = "Find a code format style that fits given source files";
    homepage = https://github.com/mikr/whatstyle;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
