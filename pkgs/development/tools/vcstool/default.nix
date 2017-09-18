{ stdenv, fetchurl, python35Packages }:

  python35Packages.buildPythonApplication rec {
    name = "vcstool";
    version = "0.1.31";
    #no tests
    doCheck = false;

    propagatedBuildInputs = with python35Packages; [ pyyaml ];
    src = fetchurl {
        url = "mirror://pypi/v/vcstool/${name}-${version}.tar.gz";
        sha256 = "0n2zkvy2km9ky9lljf1mq5nqyqi5qqzfy2a6sgkjg2grvsk7abxc";
    };

    meta = with stdenv.lib; {
        description = "Provides a command line tool to invoke vcs commands on multiple repositories";
        homepage = "https://github.com/dirk-thomas/vcstool";
        license = licenses.bsd3;
    };
}
