{ lib
, python2
, fetchFromGitHub
}:

let
  python = python2.override {
    packageOverrides = self: super: {
      # Older version, used by syncserver, tokenserver and serversyncstorage
      cornice = super.cornice.overridePythonAttrs (oldAttrs: rec {
        version = "0.17";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1vvymhf6ydc885ygqiqpa39xr9v302i1l6nzirjnczqy9llyqvpj";
        };
      });

      pyramid = super.pyramid.overridePythonAttrs (oldAttrs: {
        # Depends on webtest, which is not supported on Python 2.
        checkInputs = [];
        doCheck = false;
      });
    };
  };

# buildPythonPackage is necessary for syncserver to work with gunicorn or paster scripts
in python.pkgs.buildPythonPackage rec {
  pname = "syncserver";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "syncserver";
    rev = version;
    sha256 = "0s13pbzjldpiyz6hgw5djwnwd8q7dai6c28vrb1vqanxhrfm1rwb";
  };

  # There are no tests
  doCheck = false;

  propagatedBuildInputs = with python.pkgs; [
    cornice
    gunicorn
    pyramid
    requests
    sqlalchemy
    configparser
    mozsvc
    futures
    soupsieve
    umemcache
    tokenserver
    serversyncstorage
    google-cloud-spanner
  ];

  meta = with lib; {
    description = "Run-Your-Own Firefox Sync Server";
    homepage = "https://github.com/mozilla-services/syncserver";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = with maintainers; [ nadrieril ];
  };
}
