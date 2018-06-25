{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27, isPyPy, mock, futures  }:
buildPythonPackage rec {
  pname = "trollius";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xny8y12x3wrflmyn6xi8a7n3m3ac80fgmgzphx5jbbaxkjcm148";
  };

  checkInputs = [ mock ];

  propagatedBuildInputs = lib.optionals (isPy27 || isPyPy) [ futures ];

  patches = [
    ./tests.patch
  ];

  # Some of the tests fail on darwin with `error: AF_UNIX path too long'
  # because of the *long* path names for sockets
  patchPhase = lib.optionalString stdenv.isDarwin ''
      sed -i -e "s|test_create_ssl_unix_connection|skip_test_create_ssl_unix_connection|g" tests/test_events.py
      sed -i -e "s|test_create_unix_connection|skip_test_create_unix_connection|g" tests/test_events.py
      sed -i -e "s|test_create_unix_server_existing_path_nonsock|skip_test_create_unix_server_existing_path_nonsock|g" tests/test_unix_events.py
      sed -i -e "s|test_create_unix_server_existing_path_sock|skip_test_create_unix_server_existing_path_sock|g" tests/test_unix_events.py
      sed -i -e "s|test_create_unix_server_ssl_verified|skip_test_create_unix_server_ssl_verified|g" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl_verify_failed|skip_test_create_unix_server_ssl_verify_failed|g" tests/test_events.py
      sed -i -e "s|test_create_unix_server_ssl|skip_test_create_unix_server_ssl|g" tests/test_events.py
      sed -i -e "s|test_create_unix_server|skip_test_create_unix_server|g" tests/test_events.py
      sed -i -e "s|test_open_unix_connection_error|skip_test_open_unix_connection_error|g" tests/test_streams.py
      sed -i -e "s|test_open_unix_connection_no_loop_ssl|skip_test_open_unix_connection_no_loop_ssl|g" tests/test_streams.py
      sed -i -e "s|test_open_unix_connection|skip_test_open_unix_connection|g" tests/test_streams.py
      sed -i -e "s|test_pause_reading|skip_test_pause_reading|g" tests/test_subprocess.py
      sed -i -e "s|test_read_pty_output|skip_test_read_pty_output|g" tests/test_events.py
      sed -i -e "s|test_start_unix_server|skip_test_start_unix_server|g" tests/test_streams.py
      sed -i -e "s|test_unix_sock_client_ops|skip_test_unix_sock_client_ops|g" tests/test_events.py
      sed -i -e "s|test_write_pty|skip_test_write_pty|g" tests/test_events.py
  '';

  meta = with stdenv.lib; {
    description = "Port of the Tulip project (asyncio module, PEP 3156) on Python 2";
    homepage = "https://bitbucket.org/enovance/trollius";
    license = licenses.asl20;
    maintainers = with maintainers; [ garbas ];
  };
}
