{ stdenv, buildPythonApplication, fetchPypi, numpy, netcdf4, future, cfunits }:

buildPythonApplication rec {
  pname = "cfchecker";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0igbn46aahszzhlk4hbk45qkgf6jrly4wx8rwp5vwqb03z846d2c";
  };

  propagatedBuildInputs = [ cfunits numpy netcdf4 future ];

  meta = with stdenv.lib; {
    description = "Check a NetCDF file complies with the Climate and Forecasts (CF) Metadata Convention";
    homepage = "https://github.com/cedadev/cf-checker";
    license = licenses.bsd3;
    maintainers = [ maintainers.jshholland ];
  };
}
