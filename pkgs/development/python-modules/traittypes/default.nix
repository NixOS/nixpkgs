{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, isPy27
, pytest
, nose
, numpy
, scipy
, pandas
, xarray
, traitlets
}:

buildPythonPackage rec {
  pname = "traittypes";
  version = "unstable-2019-06-23";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jupyter-widgets";
    repo = pname;
    rev = "0a030b928991dec732c17a7a1cb13acbcd7650a2";
    sha256 = "0rlm5krmq6n8yi47dgdsjyrkz3m079pndpbzkz2gx98pb3jd9pjs";
  };

  patches = [
    (fetchpatch {
       name = "fix-intarray-test.patch";
       url = "https://github.com/minrk/traittypes/commit/a02441e5b259e5858453a853207260c9bd4efbb5.patch";
       sha256 = "120dsvr5nksizw75z1ah3h38mi399fxbvz5anakica557jahi0aw";
    })
  ];

  propagatedBuildInputs = [ traitlets ];

  checkInputs = [ numpy pandas xarray nose pytest ];

  meta = with lib; {
    description = "Trait types for NumPy, SciPy, XArray, and Pandas";
    homepage = "https://github.com/jupyter-widgets/traittypes";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };

}
