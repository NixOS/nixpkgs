{ python3Packages
, fetchFromGitHub
, gcc
, lib
}:

python3Packages.buildPythonApplication rec {
  pname = "resolve-march-native";
  version = "unstable-2022-07-29";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = "acfc87875e19ae9d4b0e5c9de1d21bc259415336";
    hash = "sha256-Hdy8/fJXQV3p51EggyLqE2t00O0phwZjbqPhhMQKT5E=";
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
