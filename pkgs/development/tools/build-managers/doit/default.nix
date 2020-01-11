{ stdenv, fetchurl, python3Packages }:

let

  name = "doit";
  version = "0.32.0";

in python3Packages.buildPythonApplication {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/${name}/${name}-${version}.tar.gz";
    sha256 = "033m6y9763l81kgqd07rm62bngv3dsm3k9p28nwsn2qawl8h8g9j";
  };

  buildInputs = with python3Packages; [ mock pytest ];

  propagatedBuildInputs = with python3Packages; [ cloudpickle ]
    ++ stdenv.lib.optional stdenv.isLinux pyinotify
    ++ stdenv.lib.optional stdenv.isDarwin macfsevents;

  # Tests fail due to mysterious gdbm.open() resource temporarily
  # unavailable errors.
  doCheck = false;
  checkPhase = "py.test";

  meta = with stdenv.lib; {
    homepage = https://pydoit.org/;
    description = "A task management & automation tool";
    license = licenses.mit;
    longDescription = ''
      doit is a modern open-source build-tool written in python
      designed to be simple to use and flexible to deal with complex
      work-flows. It is specially suitable for building and managing
      custom work-flows where there is no out-of-the-box solution
      available.
    '';
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.all;
  };
}
