{ llvmPackages_16
, lib
, fetchFromGitHub

# build time
, cmake
, git

# runtime
, boost
, bzip2
, icu
, libmysqlclient
, mariadb
, readline

# version specifics
, version
, owner ? "TrinityCore"
, repo ? "TrinityCore"
, rev ? version
, hash

# genrev
, branch ? "master"
, commit

# patches
, extraPatches ? []
, broken ? false
, ...
}:

llvmPackages_16.stdenv.mkDerivation {
  pname = "TrinityCore";
  inherit version;

  src = fetchFromGitHub {
    inherit owner repo rev hash;
  };

  patches = extraPatches;

  postPatch = ''
    substituteInPlace cmake/genrev.cmake \
      --replace "set(rev_hash \"unknown\")" "set(rev_hash \"${commit}\")" \
      --replace "set(rev_branch \"Archived\")" "set(rev_branch \"${branch}\")"
  '';

  nativeBuildInputs = [
    cmake
    git
  ];

  buildInputs = [
    boost
    bzip2
    icu
    libmysqlclient
    readline
  ];

  cmakeFlags = [
    "-DWITHOUT_GIT=YES"
    "-DMYSQL_HOME=${libmysqlclient}/lib/mysql"
    "-DMYSQL_INCLUDE_DIR=${libmysqlclient.dev}/include/mysql"
    # Necessary for worldserver performing database manipulations
    "-DMYSQL_EXECUTABLE=${mariadb}/bin/mysql"
  ];

  postInstall = ''
    cp -Rv ../sql $out/sql
  '';

  passthru.updateScript = [ ./update.py branch ];

  meta = with lib; {
    description = "TrinityCore Open Source MMO Framework";
    downloadPage = "https://github.com/TrinityCore/TrinityCore";
    homepage = "https://www.trinitycore.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raitobezarius hexa ];
    inherit broken;
  };
}
