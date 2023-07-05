{ python3Packages
, fetchFromGitHub
, gcc
, lib
}:

python3Packages.buildPythonApplication rec {
  pname = "resolve-march-native";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vJzkVL23fvFO1pGJwdPiqR73K9iNJ6OglVxL5tCVa2U=";
  };

  # NB: The tool uses gcc at runtime to resolve the -march=native flags
  propagatedBuildInputs = [ gcc ];

  doCheck = true;

  meta = with lib; {
    description = "Tool to determine what GCC flags -march=native would resolve into";
    homepage = "https://github.com/hartwork/resolve-march-native";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
