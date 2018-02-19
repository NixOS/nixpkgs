{ lib
, fetchurl
, python2Packages
, stdenv
}:

python2Packages.buildPythonApplication rec {
    name = "mackup-0.8.16";

    src = fetchurl {
        url = "https://pypi.python.org/packages/e5/3a/e8a422e88dab6f734706a7612adc4715cc44512d48845295ceea7a9fc244/${name}.tar.gz";
        sha256 = "0f5cb5srxa3bn7lbfs5rb4iqjs57blzvgypivndy756vsvm9ijrv";
    };

    "docopt" = python2Packages.buildPythonPackage {
        name = "docopt-0.6.2";
        doCheck = false;
        src = fetchurl {
            url = "https://pypi.python.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz";
            sha256 = "14f4hn6d1j4b99svwbaji8n2zj58qicyz19mm0x6pmhb50jsics9";
        };
    };

    propagatedBuildInputs = [ docopt ];

    meta = with stdenv.lib; {
        homepage = https://github.com/lra/mackup;
        description = "Keep your application settings in sync (OS X/Linux)";
        license = licenses.gpl3;
        maintainers = with maintainers; [ joshuaks ];
    };
}

