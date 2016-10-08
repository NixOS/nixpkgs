{ python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  name = "nixbot-unstable-2016-10-08";

  src = fetchFromGitHub {
    owner = "domenkozar";
    repo = "nixbot";
    rev = "62cf804a76c55a365d3e95d003e3126b20f6b124";
    sha256 = "0x9x9dhcqyd4frgwl39sksjd4lwni6vrqss9b9phm5gxhgmhsqvp";
  };

  propagatedBuildInputs = with python3Packages; [
    pygit2 pyramid pyramid_chameleon pyramid_debugtoolbar waitress github3_py
  ];

  doCheck = false;
}
