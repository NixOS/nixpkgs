{ lib
, fetchurl
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "flawfinder";
  version = "2.0.19";

  src = fetchurl {
    url = "https://dwheeler.com/flawfinder/flawfinder-${version}.tar.gz";
    sha256 = "sha256-/lUJgdNwq/oKKWcTRswLA4Ipqb2QsjnqsPAfEiEt9hg=";
  };

  # Project is using a combination of bash/Python for the tests
  doCheck = false;

  pythonImportsCheck = [ "flawfinder" ];

  meta = with lib; {
    description = "Tool to examines C/C++ source code for security flaws";
    homepage = "https://dwheeler.com/flawfinder/";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
